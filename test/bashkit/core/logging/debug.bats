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


@test "displays at level 7 and reraises code" {
    f() {
        logging::setlevel 1
        (exit 1) || debug 'unreachable' || echo $?

        logging::setlevel 7
        (exit 7) || debug 'passed #7'
    }
    run -7 f

    refute_output -p 'unreachable'
    assert_output -p '1'
    assert_log 'debug' 'f' 'passed #7'
}

@test "reraises code" {
    f() {
        logging::setlevel 7
        (exit 1) || debug 'passed #1'
    }
    run -1 f
    assert_log 'debug' 'f' 'passed #1'

    f() {
        logging::setlevel
        (exit 2) || debug 'unreachable'
    }
    run -2 f
    refute_output -p 'unreachable'
    assert_output ''
}

@test "displays \${__} or '' when called without reason" {
    f() {
        logging::setlevel 7
        __="__"
        false || debug
    }
    run -1 f
    assert_log 'debug' 'f' '__'

    f() {
        logging::setlevel 7
        false || debug
    }
    run -1 f
    assert_log 'debug' 'f' ''
}
