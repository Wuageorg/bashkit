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


@test "displays at level >=1 and reraises code" {
    f() {
        logging::setlevel 0
        (exit 0) && alert 'unreachable' && echo $?

        logging::setlevel 1
        (exit 1) || alert 'passed #1' || echo $?

        logging::setlevel 2
        (exit 2) || alert 'passed #2'
    }
    run -2 f

    refute_output -p 'unreachable'
    assert_output -p '0'
    assert_output -p '1'
    assert_log 'alert' 'f' 'passed #1'
    assert_log 'alert' 'f' 'passed #2'
}

@test "reraises code" {
    f() {
        (exit 1) || alert "passed #1"
    }

    run -1 f
    assert_log 'alert' 'f' 'passed #1'
}
