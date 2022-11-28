#!/usr/bin/env bash
# check.bash --
# bashkit module
# implements checking routines
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash check\n'
    exit 1
fi

# module init declares a cmd cache along an exit callback to clean it up
check::init() {
    if declare -p __CHECKCACHE &> /dev/null; then
        return 0  # already initialized
    fi
    declare -g -A __CHECKCACHE=( [${FUNCNAME[0]}]=1 )  # declare and initialize
    cleanup 'unset __CHECKCACHE'

    debug done!
}

check::cmd() {
    # check if a shell command is available
    local cmd
    for cmd; do
        # lookup cache first
        if [[ -v __CHECKCACHE[${cmd}] ]]; then
            continue; # found!
        fi

        # else test command
        command -v "${cmd}" &> /dev/null \
        || raise "${E_COMMAND_NOT_FOUND}" "${cmd} not found" \
        || return $?  # if no errcode trap

        __CHECKCACHE+=( [${cmd}]=1 )  # cache command is available (positive cache)
    done
}

check::dir() {
    # check if directory exists or create it otherwise
    local dir
    for dir; do
        if [[ ! -d ${dir} ]]; then
            debug "making ${dir}"
            __=$(mkdir -p "${dir}" 2>&1) \
            || raise \
            || return $?
        fi
    done
}

check::vartype() {
    # check var type and attributes
    # adapted from https://stackoverflow.com/a/42877229
    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    # try to not shadow casual outside vars
    local __want__=$1 __var__=$2 __def__

    __def__=$(declare -p "${__var__}" 2> /dev/null) \
    || raise "${E_PARAM_ERR}" "${__var__}: not found" \
    || return $?

    #debug "var: ${__var__} def: ${__def__} want:${__want__}"

    # check nameref
    local __nameref__='^declare -n ([^=]+)(=\"([^\"]+)\")?$'
    [[ ${__want__} = "${__want__//n}" ]] || {
        [[ ${__def__} =~ ${__nameref__} ]] \
        || raise "${E_PARAM_ERR}" "${__var__}: not n" \
        || return $?

        __want__=${__want__//n}  # consume 'n'
    }

    # assert we want more or we're done
    (( ${#__want__} )) \
    || return 0

    # deref until pointee
    while [[ ${__def__} =~ ${__nameref__} ]]; do
        __var__=${BASH_REMATCH[3]}
        __def__=$( declare -p "${__var__}" 2> /dev/null ) \
        || raise "${E_PARAM_ERR}" "${__var__}: not found" \
        || return $?
        # debug "var: ${__var__} def: ${__def__}"
    done

    # assert we want more
    (( ${#__want__} )) \
    || return 0

    local __declared__='^declare -([^ ]+) ([^=]+)(=(\"([^\"]+)*\"|\(([^\)]*)\)))?$'
    [[ ${__def__} =~ ${__declared__} ]] \
    || raise "${E_PARAM_ERR}" "${__var__}: not found" \
    || return $?

    # get var attibutes, name and value
    __var__=${BASH_REMATCH[2]}  # var name
    local __attrs__=${BASH_REMATCH[1]}  # var attributes -- see builtin declare
    local __val__=''  # $var is declared but unassigned...
    if (( ${#BASH_REMATCH[@]} > 2 )); then # ... empty, literal or array items otherwise
        if (( ${#BASH_REMATCH[4]} )); then __val__=0; fi; # $var is declared and empty
        if (( ${#BASH_REMATCH[5]} )); then __val__=${BASH_REMATCH[5]}; fi # literal
        if (( ${#BASH_REMATCH[6]} )); then __val__=${BASH_REMATCH[6]}; fi # array items
    fi

    # check for function
    if [[ ${__want__} != "${__want__//f}" ]]; then
        declare -f "${__val__}" > /dev/null 2>&1 \
        || raise "${E_PARAM_ERR}" "${__var__} (${__val__}): not f" \
        || return $?

        __want__=${__want__//f}   # remove 'f'
        __attrs__=${__attrs__//-} # remove '-'
    fi

    # check if var is set
    if [[ ${__want__} != "${__want__//s}" ]]; then
        [[ ${__val__} ]] \
        || raise "${E_PARAM_ERR}" "${__var__}: not set" \
        || return $?

        __want__=${__want__//s}  # remove 's'
    fi

    # assert still something to check
    (( ${#__attrs__} != 0 || ${#__want__} == 0 )) \
    || raise "${E_PARAM_ERR}" "attributes ${__want__} not set" \
    || return $?

    if (( ${#__want__} == 0 )); then return 0; fi  # success!

    # check remaining a, A, i, l, n, r, t, u, x
    local __attr__
    local -A __MAP__
    [[ ${__attrs__} =~ ${__attrs__//?/(.)} ]]  # split into array (!)
    for __attr__ in "${BASH_REMATCH[@]:1}"; do
        __MAP__+=( [${__attr__}]=1 );
    done

    [[ ${__want__} =~ ${__want__//?/(.)} ]]    # split into array (!!)
    for __attr__ in "${BASH_REMATCH[@]:1}"; do
        [[ -v __MAP__[${__attr__}] ]] \
        || raise "${E_PARAM_ERR}" "${__var__}: not ${__attr__}" \
        || return $?
    done
} 2> /dev/null

check::init "$@"
