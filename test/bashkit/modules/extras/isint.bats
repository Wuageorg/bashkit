#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

# shellcheck source=/dev/null  # extras in path
source extras.bash


@test "fails when no arg" {
    f() {
        isint
    }
    run -9 f
    assert_output 'fatal: incorrect invocation'
}

@test "succeeds on 8x4 random ints" {
    local i
    for (( i=0; i<8; i++ )); do
        isint "${RANDOM}" "${RANDOM}" "${RANDOM}" "${RANDOM}"
    done
}

@test "fails on string" {
    f() {
        isint "nope" \
        || fatal
    }
    run -1 f
    assert_output 'fatal: invalid number'
}

@test "is undefined on arrays" {
    f() {
        local -a A=( 1 2 3 )
        # shellcheck disable=SC2128  # on purpose
        isint "${A}"
    }
    run -0 f
    assert_output ''

    g() {
        local -a A=( a b c )
        # shellcheck disable=SC2128  # on purpose
        isint "${A}"
    }
    run -1 g
    assert_output ''
}
