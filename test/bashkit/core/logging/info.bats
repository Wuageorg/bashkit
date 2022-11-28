#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck disable=SC2154  # __LOGGING[level] exists
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source logging.bash


@test "displays at level >=6" {
    f() {
        logging::setlevel 0
        info 'unreachable' && echo $?  # 0

        logging::setlevel 1
        (exit 1) || info 'unreachable'

        logging::setlevel 2
        (exit 2) || info 'unreachable'

        logging::setlevel 3
        (exit 3) || info 'unreachable'

        logging::setlevel 4
        (exit 4) || info 'unreachable'

        logging::setlevel 5
        (exit 5) || info 'unreachable'

        logging::setlevel 6
        (exit 6) || info 'passed #6'

        logging::setlevel 7
        (exit 7) || info 'passed #7'
    }
    run -0 f

    refute_output -p 'unreachable'
    refute_output -e '^[1-9]$'
    assert_output -p '0'
    assert_log 'info' 'f' 'passed #6'
    assert_log 'info' 'f' 'passed #7'
}

@test "is not a valid errcode handler" {
    is_bashand && skip 'need bash';

    run -1 bash -c '
    source bashkit.bash
    (exit 1) || info "unreachable"
    '
    refute_output -p 'unreachable'
}

@test "can be used in combination with resume" {
    run -0 bash -c '
    source bashkit.bash
    (exit 1) || resume info "passed #1"
    '
    assert_log 'info' '' 'passed #1'
}

@test "displays \${__} or '' when called without reason" {
    f() {
        __="__"
        false || info
    }
    run -0 f
    assert_log 'info' 'f' '__'

    f() {
        false || resume info
    }
    run -0 f
    assert_log 'info' 'f' ''
}
