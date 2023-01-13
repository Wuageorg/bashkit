#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck disable=SC2034  # vars are used
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source check.bash


@test "suceeds if command exists" {
    f() {
        check::cmd ls
    }
    run -0 f
    assert_output ''
}

@test "fails if no command" {
    f() {
        check::cmd inexistent_command \
        || error
    }
    run -127 f
    assert_output 'error: inexistent_command not found'
}

@test "works for functions" {
    _rc1=0
    check::cmd check::cmd \
    || _rc1=$?

    _rc2=0
    hello() { echo "hello world!"; }
    check::cmd hello \
    || _rc2=$?

    assert_equal $(( _rc1 + _rc2 )) 0
}

@test "fails if not a command" {
    f() {
        local nocmd=1
        check::cmd nocmd \
        || error
    }
    run -127 f
    assert_output 'error: nocmd not found'
}

@test "nop if bad invocation" {
    _rc=0
    check::cmd \
    || _rc=$?

    assert_equal "${_rc}" 0
    assert_equal "${__}" ''
}
