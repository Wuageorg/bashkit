#!/usr/bin/env bash
# bashkit.bash --
# wuage bash script devkit
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

# bashkit base entry point
bashkit::main() {
    # strict-mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
    # bashkit does not use 'set -e' but its own errcode handler
    set -o nounset
    set -o pipefail

    IFS=$'\n\t'

    # enable DEBUG trap
    shopt -u extdebug  # errtrace is implied
    set -o functrace   # functrace must appear after extdebug

    # activate aliases expansion globally for errcode
    shopt -s expand_aliases

    # activate lastpipe globally
    # does not work in interactive mode or if job control is
    # on (ie. set -m)
    shopt -s lastpipe

    # activate default_connector_and_and shopt if available
    shopt -s default_connector_and_and 2>/dev/null || true

    # there's no point in sourcing bashkit without initializing it
    bashkit::init "$@"
    unset __  # clear $__
}

bashkit::init() {
    # already initialized
    if declare -p BASHKIT &> /dev/null; then return 0; fi

    # check current bash major version because we need printf
    # strftime() and EPOCHREALTIME for instance
    local major=5
    if (( BASH_VERSINFO[0] < major )); then
        printf '%s\n' "minimum supported bash version is ${major}.0"
        exit 2
    fi

    init__pathinfo() {
        local -n __INFOS=$1;
        local src=$2

        local dir name full repo

        name=${src##*/}      # every char after last '/' is the script name
        dir=${src%"${name}"} # dir is what's left without name
        # resolve symlinks
        dir=$( cd "${dir:-.}" && pwd -P ) \
        || fatal "unable to find ${src} basedir"

        full=${dir}/${name}

        repo=$(
            git rev-parse --show-toplevel 2>/dev/null \
            || printf ''
        )

        __INFOS=(
            [basedir]=${dir}      # /absolute_path
            [fullname]=${full}    # /absolute_path/bashkit.bash
            [filename]=${name%.*} # bashkit
            [suffix]=${name##*.}  # bash
            [repository]=${repo}  # /repository
        )
    }

    # global variables
    declare -g -A BASHKIT
    init__pathinfo BASHKIT "${BASH_SOURCE[0]}"

    declare -g -A SCRIPT
    init__pathinfo SCRIPT "$0"

    # bashkit modules path, can be modified
    modpath=${BASHKIT[basedir]}/core':'${BASHKIT[basedir]}/modules
    BASHKIT_MODPATH=${BASHKIT_MODPATH:-}${BASHKIT_MODPATH:+:}${modpath}

    # load core !!! order matters !!!
    local core=( cf trap errcode error color logging version)
    case ${OSTYPE} in
        darwin*) core+=( darwin );;
        *) ;;
    esac
    bashkit::load "${core[@]}" \
    || fatal 'failed to load core modules'

    # this out of order cleanup is ok
    cleanup 'unset SCRIPT BASHKIT'

    # load every other module requested from invocation
    bashkit::load "$@"

    debug done! # logging is loaded now!
}

bashkit::help() {
    version::bashkit
    printf '%s\n' \
        "${SCRIPT[filename]} -- bashkit ${__}" \
        "Usage: ${__usage:-undefined usage}" \
        ""

    if [[ "${__help:=undefined help}" ]]; then
        printf '%s\n' \
          "${__help}" \
          ""
    fi
    if (( $# > 0 )); then
        printf '%s\n' \
          " $*" \
          ""
    fi

    exit 2
}

bashkit__modcache() {
    case $1 in
        get)
        [[ -v BASHKIT[mods] && ${BASHKIT[mods]} = *$2* ]]
        ;;
        set)
        local newmod=$2 concat
        printf -v concat '%s' \
            "${BASHKIT[mods]:-}${BASHKIT[mods]:+ }${newmod}"
        BASHKIT[mods]=${concat}
        ;;
        *) return 1 ;;
    esac
}

bashkit::load() {
    local mod path file mods=( "$@" )
    shift ${#@} # prevent arg sourcing
    for mod in "${mods[@]}"; do
        mod=${mod%.bash}

        # assert new module request or discard
        ! bashkit__modcache get "${mod}" \
        || continue  # mod loop

        while read -d ':' -r path; do
            file=${path}/${mod}.bash
            [[ -f "${file}" ]] \
            || continue  # resume path loop

            # shellcheck source=/dev/null
            source "${file}" \
            || fatal "can not source ${mod}"

            # remove relative path if any
            local modinit=${mod##*/}::init

            if declare -f "${modinit}" &> /dev/null; then
                "${modinit}"
            fi

            bashkit__modcache set "${mod}"

            continue 2  # done! resume mod loop
        done < <( printf '%s' "${BASHKIT_MODPATH}:" )

        fatal "module not found: ${mod}"
    done
}

# fatal can be used before module logging is loaded
declare -f fatal &> /dev/null \
|| fatal() { printf '%s\n' "${@:-${__:-fatal}}" >&2; exit 1; }

: sanitize source args
{
    __BASHKIT_ARGV=( "$@" )
    __shopts=$( shopt -p )  # save shopt
    {
        shopt -s extdebug       # create BASH_ARGV
        # `source bashkit.bash` has no arg
        if [[ ${BASH_ARGV[0]:-} == "${BASH_SOURCE[0]:-}" ]]; then
            __BASHKIT_ARGV=() # clear `${__BASHKIT_ARGV[@]}`
        fi
    }
    eval "${__shopts}" && unset __shopts # restore shopt
} 2>/dev/null

bashkit::main "${__BASHKIT_ARGV[@]}" || fatal
unset __BASHKIT_ARGV
