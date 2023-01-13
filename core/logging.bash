#!/usr/bin/env bash
# logging.bash --
# bash module part of bashkit
# pretty standard logging routines
# this module may be used without bashkit
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

#  syslog verb | lvl
# -----------------------
#  panic/emerg |  0
#  alert       |  1
#  crit        |  2
#  error       |  3
#  warn        |  4
#  note        |  5
#  info        |  6
#  debug       |  7

logging::init() {
    if declare -p __LOGGING &> /dev/null; then
        return 0  # already initialized
    fi

    # <timestamp> [<level>] <function>:<lineno>| <msg>
    # <level> has fix length 5
    # ex.
    # '2022-08-14 23:40:34+0200 [fatal] array::contains:35| incorrect invocation'
    local -A FMT=(
        [base]='%(%Y-%m-%d %H:%M:%S%z)T [%5s] %s%s%s:%s| %s\n'
        [color]='%(%Y-%m-%d %H:%M:%S%z)T [%5s] %b%s%b:%s| %s\n'
        [json]='{ "date": "%(%Y-%m-%d %H:%M:%S%z)T", "level": "%s", "func": "%s%s%s", "lineno": "%s", "text": "%s" }\n'
    )

    declare -g -A __LOGGING=(
        [level]=6  # info logging level
        [format]=${FMT[base]}
    )

    local -A COLPAL=(  # color palette
        [panic]='underlined blinking bold white text red background'
        [alert]='bold white text red background'
        [crit]='underlined bold red text'
        [fatal]='bold red text'
        [error]='red text'
        [warn]='yellow text'
        [note]='blue text'
        [info]='green text'
        [debug]='magenta text'
        [reset]='reset'
    )

    # enable color if not disabled nor json output ...
    if ! [[ -v NO_COLOR || -v JSON ]] \
        && declare -f color::is_enabled &> /dev/null \
        && color::is_enabled; then  # ...and color mode is ready
            color::table COLPAL       # encode color palette
            local verb
            for verb in "${!COLPAL[@]}"; do  # append palette to __LOGGING
                __LOGGING+=([${verb}]=${COLPAL[${verb}]})
            done

            __LOGGING[format]=${FMT[color]}  # color is ready
    fi

    # enable json upon request
    if [[ -v JSON ]]; then
        __LOGGING[format]=${FMT[json]}  # json is ready
    fi

    # set requested logging level or default to 6
    logging::setlevel "${LOGLEVEL:=6}"

    # utils/environment basic replacements if not used within bashkit
    : declare minimal bashkit functions  # anote TRACE
    {
        local -A BASICS=(
            [catch]='{ ____=$?; }'
            [cleanup]='{ trap "$@" EXIT; }'
        )

        local fun
        for fun in "${!BASICS[@]}"; do
            declare -f "${fun}" &>/dev/null ||
                eval "${fun}() ${BASICS[${fun}]}"
        done
    } 2>/dev/null  # suppress from trace

    # generate logging routines such as:
    # debug() {
    #   catch
    #   if (( __LOGGING[level] >= 7 )); then logging__log "debug" "$@"; fi
    # }
    # fatal, alert, crit and debug are errcode handlers
    # warn, note, info are NOT errcode handlers

    # shellcheck disable=SC2016  # we don't want errcode to expand
    local errcode='${__log__rc}'
    local -A ROUTINES=(  # definitions
        [panic]="level=0|final=exit 1|cond=1"           # handler, exit 1
        [fatal]="level=0|final=exit ${errcode}|cond=1"  # handler, exit errcode
        [alert]="level=1|final=return ${errcode}"       # handler, reraise errcode
        [crit]="level=2|final=return ${errcode}"        # handler, reraise errcode
        [error]="level=3|final=return ${errcode}"       # handler, reraise errcode
        [warn]="level=4"                                # no handler
        [note]="level=5"                                # no handler
        [info]="level=6"                                # no handler
        [debug]="level=7|final=return ${errcode}"       # handler, reraise errcode
    )
    unset errcode

    for verb in "${!ROUTINES[@]}"; do  # panic, fatal, ...
        local level final cond IFS
        IFS='|' read -r level final cond <<< "${ROUTINES[${verb}]}"  # definitions
        level=${level##*=} final=${final##*=} cond=${cond##*=}       # values

        # generate routine
        eval "${verb}() {
            catch __log__rc
            if (( ${cond:-__LOGGING[level] >= ${level}} )); then
                logging__log \"${verb}\" \"\$@\"
            fi
            ${final:-:}  # success if no final
        }"
    done

    # backtrace errors
    if [[ -v REPORT ]]; then
        trap 'logging__report "${FUNCNAME:-.}" ${LINENO}' ERR
    fi

    if [[ -v TRACE ]]; then logging__xtrace; fi

    cleanup 'unset __LOGGING;'

    debug done!
}

logging::level() {
    __=${__LOGGING[level]}
    printf '%s\n' "${__}"
}

logging::setlevel() {
    # set requested logging level or default
    local level=${1:-6}

    # sanitize level
    case ${level} in
        [0-7]) ;;  # pass
        panic|emerg) level=0 ;;
        alert)       level=1 ;;
        crit)        level=2 ;;
        error)       level=3 ;;
        warn)        level=4 ;;
        note)        level=5 ;;
        info)        level=6 ;;
        debug)       level=7 ;;
        *)           level=6 ;;  # default when bad arg
    esac
    __LOGGING[level]=${level} # set!
    __=${level}
}

logging__log() {
    local verb=$1
    shift

    if (($# > 0)); then
        local __=()  # shadow $__
    fi

    # logging context possibly according to errcode raise
    local from lino depth

    # find caller, try 1) errcode 2) the usual and default to:
    # main:1
    depth=2
    from=${__[2]:-${__[1]:-${FUNCNAME[depth]:-main}}}
    lino=${__[3]:-${BASH_LINENO[depth - 1]:-1}}

    # recurse to caller of resume
    if [[ ${from} = resume ]]; then
        depth=3
        from=${FUNCNAME[depth]:-$0}
        lino=${BASH_LINENO[depth - 1]:-${lino}}
    fi

    # use $0 if at top-level and no main in the calling stack
    if [[ ${from} = main && ! -v FUNCNAME[depth+1] ]]; then
        from=$0
    fi

    # prepare output
    local color reset
    color=${__LOGGING[${verb}]:-}
    reset=${__LOGGING[reset]:-}

    # batch output
    local msg IFS
    while IFS= read -r msg; do
        # shellcheck disable=SC2059  # allow variable log format
        printf "${__LOGGING[format]}" \
        -1 "${verb}" "${color:-}" "${from}" "${reset:-}" "${lino}" "${msg}" >&2
    done <<< "${@:-${__:-}}"
}

logging__report() {
    local errcode=$?

    _() {
        # shellcheck disable=SC2154
        error "error: ${__file:-}:$1:$2"  # should be ($1, $2) = (func, msg)
    }

    _ "$@"
    exit "${errcode}"
}

logging__xtrace() {
    __LOGGING[level]=7  # debug level

    set -o xtrace
    PS4='+(${BASH_SOURCE:-}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
    trap 'logging__report "${FUNCNAME:-bash}" ${LINENO}' ERR  # backtrace errors
}

logging::init "$@"
