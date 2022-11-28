#!/usr/bin/env bash
# error.bash --
# bashkit module
# error codes
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

error::init() {
    if declare -p __ERRORS &> /dev/null; then
        return 0;  # already initialized
    fi

    declare -g -A __ERRORS=(
        # success, failure and misuse are from bash
        [E_SUCCESS]=0
        [E_FAILURE]=1
        [E_MISUSE]=2
        [E_UNSUPPORTED]=3  # from getent
        # [4, 7] are free

        # bashkit errors have bit 3 or 4 set
        [E_BASHKIT]=$((       (1<<3)     ))
        [E_PARAM_ERR]=$((     (1<<3) + 1 ))
        [E_ASSERT_FAILED]=$(( (1<<3) + 2 ))
        [E_PARTIAL]=$((       (1<<3) + 3 ))

        # custom errors have bit 5 or 6 set but are capped by E_TIMEOUT
        [E_CUSTOM]=$(( 1<<5 ))

        # remaining are from bash
        # for [124-127] see timeout(1)
        [E_TIMEOUT]=124
        [E_CANNOT_TIMEOUT]=125
        [E_CANNOT_EXECUTE]=126
        [E_COMMAND_NOT_FOUND]=127
        [E_INVALID_EXIT]=128

        # signal errors have bit 7 set and > 128
        # only hup, int and term are catchable others may come from a subshell
        [E_SIGHUP]=$((     (1<<7) + 1  ))
        [E_SIGINT]=$((     (1<<7) + 2  ))  # CTRL-C (130)
        [E_SIGQUIT]=$((    (1<<7) + 3  ))
        [E_SIGILL]=$((     (1<<7) + 4  ))
        [E_SIGTRAP]=$((    (1<<7) + 5  ))
        [E_SIGABRT]=$((    (1<<7) + 6  ))
        [E_SIGEMT]=$((     (1<<7) + 7  ))
        [E_SIGFPE]=$((     (1<<7) + 8  ))
        [E_SIGKILL]=$((    (1<<7) + 9  ))
        [E_SIGBUS]=$((     (1<<7) + 10 ))
        [E_SIGSEGV]=$((    (1<<7) + 11 ))
        [E_SIGSYS]=$((     (1<<7) + 12 ))
        [E_SIGPIPE]=$((    (1<<7) + 13 ))
        [E_SIGALRM]=$((    (1<<7) + 14 ))
        [E_SIGTERM]=$((    (1<<7) + 15 ))
        [E_SIGURG]=$((     (1<<7) + 16 ))
        [E_SIGSTOP]=$((    (1<<7) + 17 ))
        [E_SIGTSTP]=$((    (1<<7) + 18 ))
        [E_SIGCONT]=$((    (1<<7) + 19 ))
        [E_SIGCHLD]=$((    (1<<7) + 20 ))
        [E_SIGTTIN]=$((    (1<<7) + 21 ))
        [E_SIGTTOU]=$((    (1<<7) + 22 ))
        [E_SIGIO]=$((      (1<<7) + 23 ))
        [E_SIGXCPU]=$((    (1<<7) + 24 ))
        [E_SIGXFSZ]=$((    (1<<7) + 25 ))
        [E_SIGVTALRM]=$((  (1<<7) + 26 ))
        [E_SIGPROF]=$((    (1<<7) + 27 ))
        [E_SIGWINCH]=$((   (1<<7) + 28 ))
        [E_SIGINFO]=$((    (1<<7) + 29 ))
        [E_SIGUSR1]=$((    (1<<7) + 30 ))
        [E_SIGUSR2]=$((    (1<<7) + 31 ))
        [E_SIGWAITING]=$(( (1<<7) + 32 ))
        [E_SIGLWP]=$((     (1<<7) + 33 ))
        [E_SIGRTMIN]=$((   (1<<7) + 34 ))
        [E_SIGRTMIN1]=$((  (1<<7) + 35 ))
        [E_SIGRTMIN2]=$((  (1<<7) + 36 ))
        [E_SIGRTMIN3]=$((  (1<<7) + 37 ))
        [E_SIGRTMIN4]=$((  (1<<7) + 38 ))
        [E_SIGRTMIN5]=$((  (1<<7) + 39 ))
        [E_SIGRTMIN6]=$((  (1<<7) + 40 ))
        [E_SIGRTMIN7]=$((  (1<<7) + 41 ))
        [E_SIGRTMIN8]=$((  (1<<7) + 42 ))
        [E_SIGRTMIN9]=$((  (1<<7) + 43 ))
        [E_SIGRTMIN10]=$(( (1<<7) + 44 ))
        [E_SIGRTMIN11]=$(( (1<<7) + 45 ))
        [E_SIGRTMIN12]=$(( (1<<7) + 46 ))
        [E_SIGRTMIN13]=$(( (1<<7) + 47 ))
        [E_SIGRTMIN14]=$(( (1<<7) + 48 ))
        [E_SIGRTMIN15]=$(( (1<<7) + 49 ))
        [E_SIGRTMAX14]=$(( (1<<7) + 50 ))
        [E_SIGRTMAX13]=$(( (1<<7) + 51 ))
        [E_SIGRTMAX12]=$(( (1<<7) + 52 ))
        [E_SIGRTMAX11]=$(( (1<<7) + 53 ))
        [E_SIGRTMAX10]=$(( (1<<7) + 54 ))
        [E_SIGRTMAX9]=$((  (1<<7) + 55 ))
        [E_SIGRTMAX8]=$((  (1<<7) + 56 ))
        [E_SIGRTMAX7]=$((  (1<<7) + 57 ))
        [E_SIGRTMAX6]=$((  (1<<7) + 58 ))
        [E_SIGRTMAX5]=$((  (1<<7) + 59 ))
        [E_SIGRTMAX4]=$((  (1<<7) + 60 ))
        [E_SIGRTMAX3]=$((  (1<<7) + 61 ))
        [E_SIGRTMAX2]=$((  (1<<7) + 62 ))
        [E_SIGRTMAX1]=$((  (1<<7) + 63 ))
        [E_SIGRTMAX]=$((   (1<<7) + 64 ))
        # [193, 254] are free
        [E_OUT_OF_RANGE]=255
    )
    cleanup 'unset __ERRORS'

    # build O(1) global access to error names & codes
    : declare -g E_*  # anote trace then ...
    {
        local e
        for e in "${!__ERRORS[@]}"; do
            local errcode=${__ERRORS[${e}]}

            # reverse ex. [0]=E_SUCCESS [1]=E_FAILURE...[255]=E_OUT_OF_RANGE
            __ERRORS+=( [${errcode}]=${e} )
            # global vars ex. E_SUCCESS=0 E_FAILURE=1...E_OUT_OF_RANGE]=255
            declare -g "${e}"="${errcode}"
        done
    } 2> /dev/null  # ... silence block

    # shellcheck disable=SC2016 # we don't want expansion here
    # if hacking into bashkit consider the final redirection
    cleanup '
    : unset E_*; {
        local e;
        for e in ${!__ERRORS[@]}; do
            if [[ ${e::2} = E_ ]]; then unset "${e}" ; fi;
        done;
    } 2>/dev/null'
} 2> /dev/null  # suppress trace output

# register custom error
error::custom() {
    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local name=E_${1^^} errcode=${2}
    (( errcode > 0 )) \
    || raise "${E_PARAM_ERR}" "invalid errcode" \
    || return $?

    # ex. E_VALID_ERROR_NAME vs. E_INVALID_ERROR_NAME_
    error='^E_([A-Z1-9]+)((_([A-Z1-9])+)*)$'
    [[ ${name} =~ ${error} ]] \
    || raise "${E_PARAM_ERR}" 'invalid name' \
    || return $?

    # max custom errcode value
    local max=$(( E_CANNOT_EXECUTE - E_CUSTOM ))

    (( errcode <= max )) \
    || raise "${E_PARAM_ERR}" "invalid value not in [1-${max}[" \
    || return $?

    errcode=$(( errcode + E_CUSTOM ))  # customize

    if [[ -v __ERRORS[${name}] || -v __ERRORS[${errcode}] ]]; then
        raise "${E_PARAM_ERR}" 'already defined' \
        || return $?
    fi

    __ERRORS+=( [${name}]=${errcode} )  # forward
    __ERRORS+=( [${errcode}]=${name} )  # reverse
    declare -g "${name}"=${errcode}     # global var
    cleanup "unset ${name}"

    printf -v __ '%s=%d' "${name}" "${errcode}"
}

# convenient listing tool
error::list() {
    local group=${1:-all}

    local -a RANGES  # [a, b[  a <= errcode < b
    case ${group} in
        all)     RANGES=( "${E_SUCCESS}-${E_OUT_OF_RANGE}" );;
        bash)    RANGES=(
                          "${E_SUCCESS}-${E_BASHKIT}"
                          "${E_TIMEOUT}-${E_SIGHUP}"
                        );;
        bashkit) RANGES=( "${E_BASHKIT}-${E_CUSTOM}" );;
        custom)  RANGES=( "${E_CUSTOM}-${E_TIMEOUT}" );;
        signal)  RANGES=( "${E_SIGHUP}-${E_OUT_OF_RANGE}");;
        *) raise "${E_MISUSE}" 'bad command' || fatal;;
    esac

    local r
    for r in "${RANGES[@]}"; do
        local e min=${r%-*} max=${r#*-}  # split range
        for (( e=min; e<max; e++ )); do
            if [[ -v __ERRORS[${e}] ]]; then
                # for pretty printing, use `error::list | column -t -s "="`
                printf '%s=%s\n' "${__ERRORS[${e}]}" "${e}"
            fi
        done
    done
}

error::class() {
    (( $# == 1 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local errcode=$1

    # mimic bash exit reduction
    # prevent errcode handler to kick-in if 0
    (( errcode &= 0xff )) || catch

    [[ -v __ERRORS[${errcode}] ]] || {
        catch
        __='not defined'; printf '%s\n' "${__}"
        raise \
        || return $?
    }

    local class
    case "${errcode}" in
        12[6-8]) class=bash;;
        0)       class=0;;
        *)       { class__log2 "${errcode}"; class=${__}; };;
    esac

    case "${class}" in
        bash)  ;;  # nothing more to do
        [0-2]) class=bash;;
        [3-4]) class=bashkit;;
        [5-6]) class=custom;;
        7)     class=signal;;
    esac

    __=${class}
    printf '%s\n' "${__}"
}

# translate error name into value and conversely
error::whatis() {
    (( $# == 1 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local e=$1  # errcode or errname
    [[ -v __ERRORS[${e}] ]] \
    || raise "${E_PARAM_ERR}" 'not defined' \
    || return $?

    printf '%s\n' "${__ERRORS[${e}]}"
    __=${__ERRORS[${e}]}
}

class__log2() {
    (( ${1:-0} > 0 )) \
    || return 1

    local n log2
    # all work lifted in C construct
    for (( log2=0, n=$1; n > 0; n>>=1, log2++ )); do :; done
    # avoid (( 0 )) raising errcode 1 at loop start by offsetting
    (( log2-- ))

    printf -v __ '%d' "${log2}"
}
