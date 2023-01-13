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


@test "displays at level >=2 and reraises code" {
    f() {
        logging::setlevel 1
        (exit 1) || crit 'unreachable' || echo $?

        logging::setlevel 2
        (exit 2) || crit "passed #2" || echo $?

        logging::setlevel 3
        (exit 3) || crit 'passed #3'
    }
    run -3 f

    refute_output -p 'unreachable'
    assert_output -p '1'
    assert_output -p '2'
    assert_log 'crit' 'f' 'passed #2'
    assert_log 'crit' 'f' 'passed #3'
}

@test "reraises code" {
    f() {
        (exit 1) || crit "passed #1"
    }

    run -1 f
    assert_log 'crit' 'f' 'passed #1'
}
