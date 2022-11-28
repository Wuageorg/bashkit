#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck disable=SC2154 # __LOGGING[level] exists
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source logging.bash


@test "displays at level 0 and exits with arbitary error code" {
    f() {
        logging::setlevel 0
        (exit 1) || fatal 'passed #1'
    }
    run -1 f

    assert_log 'fatal' 'f' 'passed #1'
}

@test "reraises code" {
    test() {
        (exit 2) || fatal "passed #2"
    }

    run -2 test
    assert_log 'fatal' 'test' 'passed #2'
}

@test "displays \${__} or '' when called without reason" {
    f() {
        __="__"
        false || fatal
    }
    run -1 f
    assert_log 'fatal' 'f' '__'

    f() {
        false || fatal
    }
    run -1 f
    assert_log 'fatal' 'f' ''
}
