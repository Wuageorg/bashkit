#!/usr/bin/env bash
# extras.bash --
# bashkit module
# wuage bash programming pearls
# this module may be used without bashkit
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

funlist() {
    # Usage: funlist
    local -a FUNS
    readarray -d$'\n' -t FUNS < <( declare -F )
    printf '%s\n' "${FUNS[@]//declare -f }"
}

isint() {
    (( $# > 0)) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local i
    for i; do
        printf '%d' "${i}" > /dev/null 2>&1 \
        || raise 'invalid number' \
        || return $?
    done
}

join() {
    local IFS=$1; shift; __=$*; echo "$*";
}

now() {
    # fill $__now with the number of milliseconds elapsed since epoch
    local -n __now=${1:-__}
    # double step substitution because of locale
    local elapsed=${EPOCHREALTIME/,/.}  # either , or . in the output
    __now=$(( ${elapsed/./} / 1000 ))
}

# from https://github.com/dylanaraps/pure-bash-bible#progress-bars
progress() {
    # Usage: progress 1 10
    #                 ^----- Elapsed Percentage (0-100)
    #                    ^-- Total length in chars
    local elapsed=$(( $1*$2/100 ))

    # Create the bar with spaces.
    local prog total
    printf -v prog  "%${elapsed}s"
    printf -v total "%$(($2-elapsed))s"

    printf '%s\r' "[${prog// /-}${total}]"
}

urldecode() {
    # Usage: urldecode "string"
    local url=${1//+/ }
    printf '%b\n' "${url//%/\\x}"
}

# from https://github.com/dylanaraps/pure-bash-bible#percent-encode-a-string
urlencode() {
    # Usage: urlencode "string"
    local LC_ALL=C  # deactivate unicode
    local i car
    for (( i=0; i < ${#1}; i++ )); do
        car=${1:i:1}
        case ${car} in
            [a-zA-Z0-9.~_-])
                printf '%s' "${car}"
            ;;
            *)
                printf '%%%02X' "'${car}"
            ;;
        esac
    done
    printf '\n'
}

usleep() {
    # enter multiple subshells
    local i
    for (( i=0; i < ${1:-1}; i++ )); do
        (:;:) && (:;:) && (:;:) && (:;:) && (:;:)
    done
}
