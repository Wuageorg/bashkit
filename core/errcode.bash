#!/usr/bin/env bash
# errcode.bash --
# bashkit module
# errcode trap
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash\n'
    exit 1
fi

# prevent custom hook on DEBUG
errcode__shadow() {
    unset -f trap

    trap() {
        local arg
        for arg; do
            [[ ${arg^^} != DEBUG ]] \
            || raise 2 'trap on debug is reserved to bashkit errcode' \
            || fatal
        done

        # shellcheck disable=SC2064  # pass args now
        builtin trap "$@"
    }

    cleanup 'unset -f trap'
}

errcode::init() {
    if declare -p __CODPATS &> /dev/null; then
        return 0  # already initialized
    fi

    # shellcheck disable=SC2016  # no expansion
    #
    # errcode handling coding patterns

    declare -g -A __CODPATS
    cleanup 'unset __CODPATS'

    # shellcheck disable=SC2016  # no expansion
    #
    # errcode compatible handlers use selected keywords as their
    # first instruction. Such handlers are final expressions to
    # `||` statements (with A & B compound statements):
    # A || fatal 'goobye world!'  # keyword fatal
    # A || panic                  # keyword panic
    # A || exit 2                 # keyword exit
    # A || resume B               # keyword resume
    # A || return 1               # keyword return
    # A || true                   # keyword true
    #
    # bashkit basic handler ____=$? passes errcode to its trap
    # through $____
    # catch, resume and raise are special bashkit errcode keywords
    # alert, crit, ..., panic are bashkit logging routines
    # true, break, continue, return and exit are usual
    local -a HANDLERS=(
        # bashkit basic handler many forms:
        '____="${?}"' '____=${?}' '____="$?"' '____=$?'

        catch raise resume
        alert crit debug error fatal panic
        break continue exit return true
    )

    local h
    for h in "${HANDLERS[@]}"; do
        __CODPATS+=( [${h}]=1 )  # register $h as a valid coding pattern
    done


    # shellcheck disable=SC2016  # __errcode is literal
    #
    # ${BASH_COMMAND%% *} is $__pc.
    # $__pc is the command at hand that can catch a raising errcode. If $__pc is a
    # compatible handler of trap::errcode, it follows a bashkit sanctioned coding pat-
    # -tern. When such a handler is detected, control is transfered to it. Otherwise,
    # errcode is reraised. If an uncaught errcode reaches its calling stack root, it
    # could be handled (ie. bash `set -e`) or be the exit code.
    declare -g __errcode='
    {
        __err=$?
        if (( __err > 0 )) && ! [[ -v __CODPATS[${BASH_COMMAND%% *}] ]]; then
            if [[ -z ${__:-} ]]; then
                reason "uncaught error code ${__err}"; # set default reason
            fi
            if [[ ${FUNCNAME:-} ]]; then return ${__err}; fi  # reraise
            exit ${__err}  # calling stack root
        fi
    } 2> /dev/null'  # hacking into bashkit? consider removing this redirection!

    # if bash 5.{0, 1}.x, patch quotes for __CODPATS access
    # https://github.com/bminor/bash/blob/74091dd/CHANGES#L358
    if (( BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] < 2 )); then
        # shellcheck disable=SC2016  # __errcode is literal
        __errcode=${__errcode/'[${BASH_COMMAND%% *}]'/'['\''${BASH_COMMAND%% *}'\'']'}
    fi
    cleanup 'unset __errcode'

    # shellcheck disable=SC2016  # expect the following to be treated literally
    #
    # $__breakpoint adds a debugging console to errcode trap. It authorizes 'breakpoint' as
    # a keyword for throwing the console on the way of a raising errcode as in:
    # breakpoint
    # false || breakpoint
    declare -g __breakpoint='
    {
        __err=$?;
        __pc=${BASH_COMMAND%% *}
        (exit ${__err})
    } 2> /dev/null  # hacking into bashkit? consider removing this redirection!

    if [[ ${__pc} = breakpoint ]]; then
        echo "# ${__pc} (${__err})" > /dev/tty
        while read -r -e -p "debug> " __cmd < /dev/tty; do
            if [[ -n ${__cmd} ]]; then eval "${__cmd}"; fi
            break
        done
    fi

    {
        if (( __err > 0 )) && ! [[ -v __CODPATS[${__pc}] ]]; then
            if [[ -z ${__:-} ]]; then
                reason "uncaught error code ${__err}";
            fi
            if [[ ${FUNCNAME:-} ]]; then return ${__err}; fi
            exit ${__err}
        fi
    } 2> /dev/null'  # hacking into bashkit? consider removing this redirection!

    # if bash 5.{0, 1}.x, patch quotes for __CODPATS access
    # https://github.com/bminor/bash/blob/74091dd/CHANGES#L358
    if (( BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] < 2 )); then
        # shellcheck disable=SC2016  # __breakpoint is literal
        __breakpoint=${__breakpoint/'[${__pc}]'/'['\''${__pc}'\'']'}
    fi
    cleanup 'unset __breakpoint'

    # sugar, logic is in the trap
    breakpoint() {
        return $?  # nop
    }
    cleanup 'unset -f breakpoint'

    __unhandled() {
        ____=$? # errcode is stored in $____ (4x_)

        local __pc=${BASH_COMMAND}  # program counter
        local __rc=${____}          # store errcode

        __has_pending() {
            # shellcheck disable=SC2016 # no expansion here
            # the following pattern is unique to logging routines
            local __routine='return ${__log__rc}'

            # when level is lower than 3 error is always pending
            # because of panic, crit and alert exit strategies
            if (( ${__LOGGING[level]:-6} < 3 )); then
                unset __routine
            fi

            # there is a pending error and it is not handled by a logging routine
            [[ "${__:-}" && ${__pc} != "${__routine:-}" ]]
        }

        if __has_pending; then
            case ${BASH_SUBSHELL} in
                0) crit  ;; # pending is critical...
                *) debug ;; # ... unless it happens in subshell
            esac
        fi

        __=() # clear pending
        return "${__rc}"
    }
    trap::callback '__unhandled' ERR

    if [[ -v DEBUG && -t 2 ]]; then
        errcode::trap breakpoint
    else
        errcode::trap default  # enabled by default
    fi

} 2> /dev/null  # suppress trace output

# return false when bash default newlines command connector
# is 'and_and' (using shopt or binpatch)
errcode__is_not_bashand() {
    false
    true
}

errcode::trap() {
    cmd=${1:-status}

    case ${cmd} in
        default)
            # bash is interactive or 'and' patched
            if [[ $- == *i* ]] \
               || ! errcode__is_not_bashand; then
                return
            fi
            ;&   # fallthrough!
        enable)
            unset '__CODPATS[breakpoint]'
            # shellcheck disable=SC2064  # expand subito!
            builtin trap "${__errcode}" DEBUG
            # reserve DEBUG to errcode by shadowing builtin trap
            errcode__shadow
            ;;
        breakpoint)
            __CODPATS+=( [breakpoint]=1 )
            # shellcheck disable=SC2064  # expand subito!
            builtin trap "${__breakpoint}" DEBUG
            # reserve DEBUG to errcode by shadowing builtin trap
            errcode__shadow
            ;;
        disable)
            warn '!!! disabling errcode trap is not advised !!!'
            debug 'disabling errcode trap may result in non obvious bad script side effects'
            unset -f trap  # unshadow trap
            trap -- DEBUG
            ;;
        status)
            local trap
            trap=$( builtin trap -p DEBUG 2> /dev/null )

            (( ${#trap} )) \
            || return 1  # no trap

            [[ ${trap} = *__CODPATS* ]] \
            || return 1  # not an errcode trap
            ;;
        *)
            fatal 'bad command'
            ;;
    esac
}

errcode::init "$@"
