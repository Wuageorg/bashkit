#!/usr/bin/env bash
# version.bash --
# bashkit module
# version handler
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is not to be executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash\n'
    exit 1
fi

version::init() {
    if declare -p BASHKIT_VERSION &> /dev/null; then
        return 0  # already initialized
    fi

    version__lookup "BASHKIT_VERSION" "${BASH_SOURCE[0]}" \
    && declare -g -A "${__}" &> /dev/null \
    || raise "${E_ASSERT_FAILED}" 'BASHKIT_VERSION is missing' \
    || fatal

    if ! declare -f check::cmd &> /dev/null; then
        check::cmd() { local cmd; for cmd; do command -v "${cmd}" &> /dev/null; done; }
    fi

    debug done!
} 2> /dev/null  # suppress trace output

version::bashkit() {
    local -n __version=${1:-__}

    local semver state
    version__semver semver
    version::state state

    printf -v __version '%s' "${semver}"

    if [[ "${BASHKIT_VERSION[branch]}" != "main" ]]; then
        printf -v __version '%s.%s' "${__version}" "${BASHKIT_VERSION[branch]}"
    fi

    local hash
    if (( ${#state[@]} > 0 )); then
        version__cpphash hash "${state[*]}"
        printf -v __version '%s.%07x' "${__version}" "${hash}"
    fi
}

version::state() {
    local -n __facts=${1:-__}

    if ! check::cmd md5sum grep; then
        __facts=( 'no_hash' )
        return 0
    fi

    local hashes
    # shellcheck disable=SC2015  # declare could fail
    version__lookup BASHKIT_HASHES "${BASH_SOURCE[0]}" hashes \
    && local -A "${hashes}" &> /dev/null \
    || raise "${E_ASSERT_FAILED}" 'BASHKIT_HASHES is missing' \
    || fatal

    __facts=( )

    local fname
    while read -r fname; do
        __facts+=( "changed_${fname/: *}" )
    done < <(
        # build a checksum pseudo-file for md5sum
        __checksums() {
            local f  # file name
            for f in "${!BASHKIT_HASHES[@]}"; do
                printf '%s  %s\n' "${BASHKIT_HASHES[${f}]}" "${f}"
            done
        }

        cd "${BASHKIT[basedir]}" \
        || return 1

        # check pseudo-file __checksums and self (version removed) on stdin [-]
        # display self [-] chksum in the process - useful if you edit
        # test/core/version/state.bats test file
        #
        # md5sum --check --ignore-missing --quiet 2> /dev/null \
        #     <( __checksums ) \
        #     < <( version__remove | tee >(md5sum > /dev/tty) ) \
        # || true

        # check pseudo-file __checksums and self (version removed) on stdin (-)
        md5sum --check --ignore-missing --quiet 2> /dev/null \
            <( __checksums ) \
            < <( version__remove ) \
        || true

        unset -f __checksums
    )
}

version::update() ( # in subshell
    bashkit::load check
    check::cmd git sed

    # Move to BASHKIT basedir
    cd "${BASHKIT[basedir]}" || return 1

    local compat
    # shellcheck disable=SC2030  # compat is fine
    compat=${BASHKIT_VERSION[compat]}

    local date
    # shellcheck disable=SC2030  # date is fine
    printf -v date '%(%y%m)T' -1  # 2 digits current year and month

    local commit
    # shellcheck disable=SC2030  # commit is fine
    commit=$(
        git rev-list --count HEAD
    )
    (( commit++ ))  # match next commit

    local branch
    branch=$(
        git branch --show-current
    )
    if [[ ${branch} != main ]]; then
        warn "updating BASHKIT_VERSION on non main branch, compat set to 0"
        compat=0
    fi

    local newver
    printf -v newver \
        "#@BASHKIT_VERSION=( [compat]='%s' [date]='%s' [commit]='%s' [branch]='%s' )" \
        "${compat}" "${date}" "${commit}" "${branch}"

    local -a HASHES
    version__disthash HASHES

    local newhashes
    local IFS=' '
        printf -v newhashes "#@BASHKIT_HASHES=( %s )" "${HASHES[*]}"
    unset IFS

    sed -i \
        "s|^#@BASHKIT_VERSION=.*\$|${newver}|;s|^#@BASHKIT_HASHES=.*\$|${newhashes}|" \
        "${BASH_SOURCE[0]}"
)

version__lookup() {
    local tag='#@' var=$1 sep='='    # varname from cmd
    local tagged=${tag}${var}${sep}  # tagged line regex

    local file=$2
    local -n __out=${3:-__}
    local line

    : output first tagged line from file  # anote trace...
    {
        while read -r line; do
            if [[ ${line} = ${tagged}* ]]; then
                __out=${line##"${tag}"}  # untagged output!
                return 0
            fi
        done < "${file}"
    } 2> /dev/null  # ... and silence untractable output

    raise "${var} not found in ${file}" \
    || return $?
}

version__cpphash() {
    local -n __h=${1:-__}; shift
    local s=$*
    local i c g h=0
    for (( i=0; i < ${#s}; i++ )); do
        printf -v c '%d' "'${s:i:1}"  # c=atoi(s[i])
        h=$(( (h << 4) + c ))
        if g=$(( h & 0xf0000000 )); then
            (( h ^= g >> 24, h &= ~g ))
        fi
    done
    __h=${h}
}

version__disthash() {
    check::cmd find md5sum

    local -n __HASHES=${1:-__}
    local DISTFILES line

    readarray -d $'\0' -t DISTFILES < <(
        printf '%s\0' '-' # self
        if [[ -f bashkit.bash ]]; then printf '%s\0' "bashkit.bash"; fi
        find 'core' 'modules' -name '*.bash' -print0 -type f \
            ! -wholename "${BASH_SOURCE[0]}" \
            ! -wholename "core/version.bash"
    )

    __mkrecord() {
        local line gap='  ' && (( ${#gap} == 2 ))  # prevent kludge

        while read -r line; do
            printf "[%s]='%s'\n" "${line#*"${gap}"}" "${line%%"${gap}"*}"
        done
    }

    readarray -d $'\n' -t __HASHES < <(
        md5sum "${DISTFILES[@]}" < <( version__remove ) | __mkrecord
    )

    unset -f __mkrecord
}

# shellcheck disable=SC2120  # can be called without arg
version__remove() {
    local src=${1:-${BASH_SOURCE[0]}}

    [[ -f ${src} ]] \
    || fatal "file not found: ${src}"

    : version__remove "${src}" # anote trace...
    {
        grep -v '^#@BASHKIT' "${src}"
    } 2> /dev/null  # ... and silence untractable output
}

version__semver() {
    local -n __semver=${1:-__}
    # shellcheck disable=SC2031  # compat, date and commit are fine
    printf -v __semver '%s.%s.%s' \
        "${BASHKIT_VERSION[compat]}" \
        "${BASHKIT_VERSION[date]}" \
        "${BASHKIT_VERSION[commit]}"
}


# Generated in file version values
#@BASHKIT_VERSION=( [compat]='0' [date]='2209' [commit]='276' [branch]='' )
#@BASHKIT_HASHES=( [-]='f3b15d7b35237c74bd6f5c50de7039bd' [bashkit.bash]='21850af3b3a811d8a84a4fbb6bede6cf' [core/darwin.bash]='a87158fbd3879511d31f150c2b8cd115' [core/version.bash]='2005284bee983c4be047c4e5e6c6ede9' [core/errcode.bash]='bf34286e3f76c9d66e9f494f6ed54018' [core/color.bash]='f5dda992fd91ee4f97ed7367ed9cf128' [core/logging.bash]='9c7d7b4c4c0c43996259e8b9829b5b28' [core/error.bash]='5e59449f61d9cd2a2d30ec456079b963' [core/trap.bash]='b8c6afd5ccc4d4b2660c10cdf45a3d92' [modules/readlinkf.bash]='b959e687ef06d3f8b121dcb7c37d246b' [modules/curl.bash]='60fd4bdbcfa2c3e46383821c98a3942f' [modules/array.bash]='8df5f23f4a83123c710118cfbad90b3c' [modules/patch.bash]='a1e43691fa04e8e1590a1b182c95fdfe' [modules/check.bash]='3ab33eaf843c8ef85feca4af7f4d2235' [modules/extras.bash]='4de3dec70f022387656d5e10292b5d84' [modules/string.bash]='68cb84d7e594117755972472272fb848' [modules/perms.bash]='a26ccf7a243a7eba562abdfcd6e0f77e' [modules/json.bash]='baf74c60c3085bf335cc30923696f64c' [modules/interactive.bash]='68256f0639a6b1761892bfd7f0a77778' [modules/shopt.bash]='55705ef08e8303fb8740ca7cb8746b37' )
