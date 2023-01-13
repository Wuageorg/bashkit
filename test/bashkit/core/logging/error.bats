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


@test "displays at level >=3 and reraises code" {
    f() {
        logging::setlevel 1
        (exit 1) || error 'unreachable' || echo $?

        logging::setlevel 2
        (exit 2) || error 'unreachable' || echo $?

        logging::setlevel 3
        (exit 3) || error 'passed #3' || echo $?

        logging::setlevel 4
        (exit 4) || error 'passed #4'
    }
    run -4 f

    refute_output -p 'unreachable'
    assert_output -p '1'
    assert_output -p '2'
    assert_output -p '3'
    assert_log 'error' 'f' 'passed #3'
    assert_log 'error' 'f' 'passed #4'
}

@test "reraises code" {
    f() {
        (exit 1) || error 'passed #1'
    }

    run -1 f
    assert_log 'error' 'f' 'passed #1'
}

@test "displays \${__} or '' when called without reason" {
    f() {
        __="__"
        false || error
    }
    run -1 f
    assert_log 'error' 'f' '__'

    f() {
        false || error
    }
    run -1 f
    assert_log 'error' 'f' ''
}
