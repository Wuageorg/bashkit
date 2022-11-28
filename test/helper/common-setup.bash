#!/usr/bin/env bash
# common-setup.bash --
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

_common_setup() {
    bats_require_minimum_version 1.5.0

    # shellcheck disable=SC2034 # is used
    BATS_LIB_PATH=${BATS_ROOT}/lib
    bats_load_library bats-support
    bats_load_library bats-assert

    BATS_TESTDIR=$( cd "$( dirname "${BATS_TEST_FILENAME}" )" &> /dev/null && pwd )

    BASHKIT_ROOT=${BATS_TESTDIR%test*}
    BASHKIT_ROOT=${BASHKIT_ROOT::-1}
    PATH=${BASHKIT_ROOT}:${BASHKIT_ROOT}/core:${BASHKIT_ROOT}/modules:${PATH}

    # activate default_connector_and_and shopt if available
    shopt -s default_connector_and_and 2>/dev/null || true
}

mklogrex() {
    local -n __logrex=$1
    shift

    # use/build partial static rex for each logging line component:
    # date, time, logging level, caller function, lineno
    local date='20[0-9]{2}-[01][0-9]-[0-3][0-9]'             # 2022-10-04
    local time='[0-2][0-9]:[0-5][0-9]:[0-5][0-9]\+[0-9]{4}'  # 16:23:27+0200
    local lvl='[a-z]+'                                       # debug
    local fun='[^ :]+'                                       # logging::init
    local lno='[0-9]+'                                       # 123

    # match any logging message by default
    local msg=''

    # if any, substitute args as rex base for selected components:
    printf -v lvl '%s' "${1:-${lvl}}"
    printf -v fun '%s' "${2:-${fun}}"
    printf -v msg '%s' "${3:-}"

    # build final logging line regex
    local -a PARTS=(
        "${date} ${time}" "${lvl}" "${fun}" "${lno}" "${msg}"
    )
    printf -v __logrex '%s \[%5s\] %s:%s\| %s' "${PARTS[@]}"
}

assert_log() {
    local rex
    mklogrex rex "$@"
    assert_output -e "${rex}"
}

refute_log() {
    local rex
    mklogrex rex "$@"
    refute_output -e "${rex}"
}

bashkit_mock() {
    # mock functions to help source a module alone

    # shellcheck disable=SC2034 # BASHKIT is used
    BASHKIT=( [mock]=1 )

    # shellcheck disable=SC2034 # global var
    # no color in test, color::is_enabled
    # test if 2 is a tty, since we're sourcing
    # at top level, bats didn't redirected 2 yet
    NO_COLOR=1

    # shellcheck disable=SC2034 # global var
    E_PARAM_ERR=9 E_COMMAND_NOT_FOUND=127

    trap::callback() { :; }  # nop

    cleanup() { trap::callback "$*" EXIT; }

    debug() { :; }  # nop

    ____log_mock() { local _rc=$?; printf '%s: %s\n' "${FUNCNAME[1]}" "${@:-${__:-}}"; return ${_rc}; }

    panic() { ____log_mock "$@"; exit 1; }
    fatal() { ____log_mock "$@"; exit $?; }

    local fun
    for fun in alert crit error warn note info; do
        eval "${fun}() { ____log_mock \"\$@\"; }"
    done

    logging::setlevel() {
        case $1 in
            [7]) debug() { ____log_mock "$@"; };;
            *)   debug() { return $?; };;  # nop
        esac
    }

    # shellcheck disable=SC2120  # catch can be called without arg
    catch() {
        # errcode is stored in $____ (4x_)
        ____=$?
        local -n __rc=${1:-____}
        __rc=${____}
    }

    resume() {
        # shellcheck disable=SC2119  # catch can be called without arg
        catch; "$@"
    }

     # raise errcode and reason from cmd or stored or default to one (1)
    raise() {
        catch  # clear errcode condition

        # set $errcode from:
        #   1) $1 if a number
        #   2) $____
        #   3) default to 1
        local errcode

        # shellcheck disable=SC2015
        # A: printf B: shift C: resume printf
        # here in A && B || C, C can never run if A because A=B
        #
        # try to get errcode from $1 and consume ...
        printf -v errcode '%d' "${1:-_}" &> /dev/null && shift \
        || resume printf -v errcode '%d' ${____:-1}  &> /dev/null  # ... or try $____ or default to 1

        # assert errcode not zero (from $____) ...
        (( errcode )) \
        || resume let errcode=1  # ... or default to one

        declare -g -a __=(  # set reason
            "${*:-${__:-}}" "${BASH_SOURCE[1]:-}" "${FUNCNAME[1]:-}" "${BASH_LINENO[0]:-}"
        )
        return "${errcode}"
    }

    bashkit::load() {
        local mod
        for mod; do
            # shellcheck source=/dev/null  # file is in path
            source "${mod}.bash"
        done
    }
}

usleep() {
    # enter multiple subshells
    local i
    for (( i=0; i < ${1:-1}; i++ )); do
        (:;:) && (:;:) && (:;:) && (:;:) && (:;:)
    done
}

is_bashand() {
    eval "$(printf '%s\n' \
        "bashand__connector_test() {" \
        "   false" \
        "   true;" \
        "};"
    )"
    if bashand__connector_test; then
        unset -f bashand__connector_test
        return 1
    fi
    unset -f bashand__connector_test
    return 0
}

_common_setup "$@"
