#!/usr/bin/env bash
# trap.bash --
# bashkit module
# signal handling callbacks for shellscripts
# this module may be used without bashkit
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}" >&2
    exit 1
fi

# trap can be used without bashkit and logging so define fatal if needed
declare -f fatal &> /dev/null \
|| fatal() { printf '%s\n' "$@" >&2; exit 1; }

# cleanup handles a utility function called upon exit
cleanup() {
    local caller=${FUNCNAME[1]//[\:_]*}  # caller
    local cb=${caller}__cleanup          # callback

    # roughly sanitize new cleanup source
    local new=$*
    new=${new%"${new##*[![:space:]]}"}  # trim right
    if [[ ${new: -1} = \; ]]; then  # if any trailing ';'...
        new=${new::-1}  # ...remove it
    fi

    # (re)generate callback
    local body proto="${cb} ()" redir='2> /dev/null'

    # store current callback definition in $body
    if ! body=$( declare -f "${cb}" 2> /dev/null ); then
        # no existing callback, declare and hook $new
        eval "${proto} { ${new}; } ${redir}"
        trap::callback "${cb}" EXIT

        return 0  # done!
    fi

    # edit existing callback
    body=${body:${#proto}}     # remove header, keep body block
    body=${body:: -${#redir}}  # remove final redirection

    # pile new cleanup source up (LIFO), add redirection back,
    # and redeclare
    eval "${proto}{ ${new}; ${body}; } 2> /dev/null"
} 2> /dev/null

# add a given callback on a given signal
# added callbacks are executed in LIFO order upon signal reception
# ex:
#   trap::callback awesome_exit_func EXIT
#   trap::callback 'unset ${awesome_var}' EXIT
#   trap::callback 'echo bye!' SIGHUP SIGQUIT \
#     && trap::callback 'echo bummer!' SIGHUP
trap::callback() {
    (( $# > 0 )) \
    || return 0  # : if no arg

    local sig
    local cb=$1; shift;
    for sig; do
        trap -- "$(
            add() {
                if (( $# >= 2 )); then
                    printf "%s\n" "$3"
                fi
            } 2> /dev/null
            printf "%s\n" "${cb}"
            eval "add $( trap -p "${sig}" )" 2> /dev/null
        )" "${sig}" 2> /dev/null \
        || fatal "cannot add callback to trap ${sig}"
    done
}
