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
#@BASHKIT_VERSION=( [compat]='1' [date]='2301' [commit]='32' [branch]='main' )
#@BASHKIT_HASHES=( [-]='074d3d2d32282fa4abb82ad8f9c7db69' [bashkit.bash]='92b9a80a1467b3bf5d3e9e1eb6bf0e40' [core/darwin.bash]='ca4189a28db41c2150548f107238be91' [core/version.bash]='95f77a7c32fff8b39bf4dc646656bd20' [core/errcode.bash]='bef425287beb84e1672bfc4bcd48e8b9' [core/color.bash]='dbc61212906860345bb8f7a35e7cb80b' [core/logging.bash]='ebf82f4445faa057df162ad2321913a2' [core/error.bash]='f65362321405a279bf716c065b20a247' [core/cf.bash]='43aed7a70f7f780df9e3d9683f3d0b33' [core/trap.bash]='1830c5ef7ea9524a31efa2f03bf8bd51' [modules/readlinkf.bash]='76edc748e0d623c2e97e2c07c76b7ed3' [modules/curl.bash]='66b8adfde45af2c564268630c6c5f206' [modules/array.bash]='4fca4cc634419d96e718c355512c4ef3' [modules/patch.bash]='c3d7af72f342511a2c8856ebe5c7cdb4' [modules/check.bash]='b709d4d8e73430df2428d84446aefb4e' [modules/extras.bash]='b2a7238422ee9008eece2f3f28710449' [modules/semver.bash]='61deaf2a5a450b4a9468c2a9d07c04e1' [modules/string.bash]='5811e02ae39645365b57a9508b6923d5' [modules/perms.bash]='52e26371f8b78a13d9d75d5195b16db3' [modules/json.bash]='fd7eb07694c115f9b77d9fb94151fe9c' [modules/interactive.bash]='81ff26b4ce7742f75e278759ee35ad95' [modules/shopt.bash]='107eec313c73ff2803b8ae888452ac06' )
