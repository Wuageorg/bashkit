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


@test "displays at level 0 and exits with 1" {
    f() {
        logging::setlevel 0
        (exit 2) || panic 'passed #1'
    }
    run -1 f
    assert_log 'panic' 'f' 'passed #1'
}

@test "is a valid errcode handler that reraises code" {
    f() {
        (exit 2) || panic 'passed #2'
    }

    run -1 f
    assert_log 'panic' 'f' 'passed #2'
}

@test "displays \${__} or '' when called without reason" {
    f() {
        __="__"
        false || panic
    }
    run -1 f
    assert_log 'panic' 'f' '__'

    f() {
        false || panic
    }
    run -1 f
    assert_log 'panic' 'f' ''
}
