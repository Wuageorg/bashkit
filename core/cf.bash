#!/usr/bin/env bash
# cf.bash --
# bashkit module
# control flow
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# patch 'elif' and 'else' to be errcode compliant
alias elif='elif true &&'  # override!
alias else='else true;'    # override!

# shellcheck disable=SC2120  # catch can be called without arg
# store errcode (suspend handler) and proceed
catch() {
    # errcode is stored in $____ (4x_)
    ____=$?
    local -n __rc=${1:-____}
    __rc=${____}
} 2> /dev/null  # suppress trace output

# raise errcode and reason from cmd or stored or default to one (1)
raise() {
    catch  # clear errcode condition

    # set $errcode from:
    #   1) $1 if a number
    #   2) $____
    #   3) default to 1
    local errcode
    # save reason
    local reason=${__:-}

    # shellcheck disable=SC2015
    # in actual code A is printf, B is shift, C is resume printf
    # here in A && B || C, C can never run if A & ~B because A=B
    #
    # try to get errcode from $1 and consume it or try $____ or default to 1
    printf -v errcode '%d' "${1:-_}" &> /dev/null \
    && shift \
    || resume printf -v errcode '%d' "${____:-1}" &> /dev/null

    # assert errcode not zero (could be from $____) ...
    (( errcode )) \
    || resume let errcode=1  # ... or default to one

    reason "${*:-${reason}}" 1
    return "${errcode}"
} 2> /dev/null  # suppress trace output

# set reason for caller in __
reason() {
    local depth=$(( ${2:-0} + 1 ))
    declare -g -a __=(  # set reason for caller
        "${1:-${__:-}}" "${BASH_SOURCE[depth]:-}" "${FUNCNAME[depth]:-}" "${BASH_LINENO[depth - 1]:-0}"
    )
}

# recover from error, clear errcode and proceed from cmd
resume() {
    catch;
    __=() # clear ${__}
    "$@"
}

# logical not as a function
not() {
    ! "$@"
}
