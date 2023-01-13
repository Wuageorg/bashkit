#!/usr/bin/env bash
# shopt.bash --
# bashkit module
# implements useful shopt routines that support shopt contexts
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash shopt\n'
    exit 1
fi

shopt::init() {
    if declare -p __SHOPTSTACK &> /dev/null; then
        return 0
    fi

    declare -g -a __SHOPTSTACK
    shopt::push                   # current shopt
    cleanup 'unset __SHOPTSTACK'  # defer unset to EXIT

    debug done!
}

# shellcheck disable=SC2120  # shopt::push can be called without arg
# push current context
shopt::push() {
    local opts IFS

    IFS=$'\n' opts=$( shopt -p ) \
    || fatal 'can not read shopt'

    __SHOPTSTACK+=( "${opts}" )
    # apply options changeset no matter what
    shopt "$@" &> /dev/null \
    || true
}

# pop last context
shopt::pop() {
    local -n __st=__SHOPTSTACK
    if (( ${#__st[@]} != 0 )); then
        eval "${__st[-1]}" \
        || true  # no matter what
        unset '__st[-1]'
    fi
}

shopt::init "$@"
