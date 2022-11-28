#!/usr/bin/env bash
# interactive.bash --
# bashkit module
# interactive script utils
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf "%s is to be sourced not executed!\n" "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash interactive\n'
    exit 1
fi

interactive::init() {
    if declare -p __LOCALECACHE &> /dev/null; then
        return 0
    fi

    bashkit::load array check

    declare -g -A __LOCALECACHE=( [${FUNCNAME[0]}]=1 )

    check::cmd locale \
    || raise \
    || return $?

    # Yes/No locale
    local yn_vars
    yn_vars=$(locale -k LC_MESSAGES)
    yn_vars=${yn_vars//'messages-'}
    yn_vars=${yn_vars//\"}

    # shellcheck disable=SC2086
    # globbing/splitting is intended we want i.e. "yesexpr=^[yY]" to be
    # evaluated
    local -- ${yn_vars} >& /dev/null

    __LOCALECACHE[yexp]=${yesexpr:-^[yY]}
    __LOCALECACHE[nexp]=${noexpr:-^[nN]}
    __LOCALECACHE[ystr]=${yesstr:-yes}
    __LOCALECACHE[nstr]=${nostr:-no}
    # End of Yes/No locale

    cleanup 'unset __LOCALECACHE'

    debug done!
}

interactive::yesno() {
    # Usage: yesno "Yes/No question" [default("y"/"n")]
    local question=${1:?specify a yes/no question}
    local default=${2:-}

    (( ${#__LOCALECACHE[@]} > 0 )) \
    || raise '__LOCALECACHE not initialized' \
    || return $?

    local ystr=${__LOCALECACHE[ystr]}
    local nstr=${__LOCALECACHE[nstr]}

    if [[ -v default ]]; then
        # capitalize default answer string
        case ${default} in
            y) ystr=${ystr^^};;
            n) nstr=${nstr^^};;
        esac
    fi

    local answer=""
    while true; do
        printf '%s %s' "${question}" "[${ystr}/${nstr}]: "
        read -r answer || true

        case ${answer:-${default}} in
            y | __LOCALECACHE[yexp]) return 0;;
            n | __LOCALECACHE[nexp]) return 1;;
        esac
    done
}

interactive::init "$@"
