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


@test "displays at level >=4" {
    f() {
        logging::setlevel 0
        warn 'unreachable' && echo $?  # 0

        logging::setlevel 1
        (exit 1) || warn 'unreachable'

        logging::setlevel 2
        (exit 2) || warn 'unreachable'

        logging::setlevel 3
        (exit 3) || warn 'unreachable'

        logging::setlevel 4
        (exit 4) || warn 'passed #4'

        logging::setlevel 5
        (exit 5) || warn 'passed #5'

        logging::setlevel 6
        (exit 6) || warn 'passed #6'

        logging::setlevel 7
        (exit 7) || warn 'passed #7'
    }
    run -0 f

    refute_output -p 'unreachable'
    refute_output -e '^[1-9]$'
    assert_output -p '0'
    assert_log 'warn' 'f' 'passed #4'
    assert_log 'warn' 'f' 'passed #5'
    assert_log 'warn' 'f' 'passed #6'
    assert_log 'warn' 'f' 'passed #7'
}

@test "is not a valid errcode handler" {
    is_bashand && skip 'need bash';

    run -1 bash -c '
    source bashkit.bash
    (exit 1) || warn "unreachable"
    '
    refute_output -p 'unreachable'
}

@test "can be used in combination with resume" {
    run -0 bash -c '
    source bashkit.bash
    (exit 1) || resume warn "passed #1"
    '
    assert_log 'warn' '' 'passed #1'
}

@test "displays \${__} or '' when called without reason" {
    f() {
        __="__"
        false || warn
    }
    run -0 f
    assert_log 'warn' 'f' '__'

    f() {
        false || resume warn
    }
    run -0 f
    assert_log 'warn' 'f' ''
}
