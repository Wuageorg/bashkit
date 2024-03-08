#!/usr/bin/env bash
# darwin.bash --
# bashkit module
# implements utils for MacOSX
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if [[ ${OSTYPE} != darwin* ]]; then
    printf '%s is NOT for %s\n' "${BASH_SOURCE[0]}" "${OSTYPE}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash\n'
    exit 1
fi

darwin::init() {
    # wrap some gnu tools to be used instead of darwin's

    local -A GTOOLS=(  # usually from brew(1)
        [date]=gdate
        [ln]=gln
        [sed]=gsed
        [grep]=ggrep
    )
    # shellcheck disable=SC2016  # template is literal
    local -r tmpl='
    %s() {
        __=$( command -v %s 2>&1 ) \
        || raise "${E_COMMAND_NOT_FOUND}" \
        || error \
        || return $?

        ${__} "$@"
    }'

    # dynamically build tool wrappers from template
    local cmd wrapper
    for cmd in "${!GTOOLS[@]}"; do
        # shellcheck disable=SC2059  # allow fmt from $tmpl
        # compose wrapper source from template
        printf -v wrapper "${tmpl}" "${cmd}" "${GTOOLS[${cmd}]}"

        # declare wrapper
        eval "${wrapper}"
    done
}

# bring minimal getent to bashkit::darwin
getent() {
    local query=$1; shift;

    # assert at least one key in cmd
    (( $# != 0 )) \
    || raise 3 'listing not supported' \
    || error \
    || return $?

    local key
    for key; do
        local data
        case ${query} in
            passwd|group|hosts)
                "getent__${query}" "${key}" \
                || error \
                || return $?
                ;;
            *)
                raise 1 'database unknown' \
                || error \
                || return $?
                ;;
        esac
    done
}

getent__dscl_read() {
    local path=$1 key=$2

    local data val
    data=$( dscl -q . -read "${path}" "${key}" 2>&1 ) \
    || raise "${data:-can not dscl -read}" \
    || return $?

    # extract value
    val=${data##*:}
    val=${val#"${val%%[![:space:]]*}"}              # trim left
    printf '%s\n' "${val%"${val##*[![:space:]]}"}"  # trim right
}

# get group data from darwin group output format:
# name:password:gid:members
getent__group() {
    local key=$1; shift;
    local val path=/Groups/${key}

    val=$( getent__dscl_read "${path}" 'PrimaryGroupID' ) \
    || raise 2 "${val:-can not dscl -read}" \
    || return $?

    local group
    local -a VAL=( "${val}" )
    group=$( getent__join ":" "${key}" "x" "${VAL[@]}" "" ) \
    || raise 2 'can not build gid' \
    || return $?

    printf '%s\n' "${group}"
}

# depends on darwin sed
# get host ip from darwin host output format:
# hostname ipaddr
getent__hosts() {
    local key=$1; shift

    local -a ADDRS
    readarray -t ADDRS < <( dscacheutil -q host -a name "${key}" | sed -E '/^(name|$)/d' )

    (( ${#ADDRS[@]} != 0 )) \
    || raise 2 'host not found' \
    || return $?

    local a
    for a in "${ADDRS[@]}"; do
        printf '%s%s\n' "${key}" "${a#*:}"  # '%s%s' because ${a#*:} has a leading space
    done
}

getent__join() { local IFS=$1; shift; echo "$*"; }

# get user data from darwin passwd output format:
# name:password:uid:gid:gecos:home_dir:shell
getent__passwd() {
    local key=$1; shift;

    local field val path=/Users/${key}
    local -a VALS
    local -a FIELDS=(
        UniqueID PrimaryGroupID RealName NFSHomeDirectory UserShell
    )
    for field in "${FIELDS[@]}"; do
        val=$( getent__dscl_read "${path}" "${field}" ) \
        || raise 2 "${val:-can not dscl -read}" \
        || return $?

        if [[ ${field} = NFSHomeDirectory ]]; then
            val=${val%% *}  # user may have more than one, use the first!
        fi

        VALS+=( "${val}" )
    done

    local passwd
    passwd=$( getent__join ':' "${key}" "x" "${VALS[@]}" ) \
    || raise 2 'can not build passwd' \
    || return $?

    printf '%s\n' "${passwd}"
}

darwin::init "$@"
