#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "pushes a single item to an array" {
    f(){
        local -a A=( {1..11} )
        array::push A 12
        (( A[-1] == 12 && A[-2] == 11 )) \
        || exit 1
    }
    run -0 f
    assert_output ''
}

@test "pushes multiple items to an array" {
    f(){
        local -a A=( {1..11} )
        array::push A 12 13 14
        (( A[-1] == 14 && A[-2] == 13 && A[-3] == 12 )) \
        || exit 1
    }
    run -0 f
    assert_output ''
}

@test "works if empty arrays" {
    f() {
        # shellcheck disable=SC2030  # A is fine
        local -a A=()  # empty
        array::push A 1 \
        || raise \
        || error \
        || return $?

        (( A[-1] == 1 && ${#A[@]} == 1 )) \
        || exit 1
    }
    run -0 f
    assert_output ''
}

@test "works if uninitialized arrays" {
    f() {
        # shellcheck disable=SC2030  # A is fine
        local -a A  # uninitialized
        array::push A 1 \
        || raise \
        || error \
        || return $?

        # shellcheck disable=SC2031  # A is fine
        (( A[-1] == 1 && ${#A[@]} == 1 )) \
        || exit 1
    }
    run -0 f
    assert_output ''
}

@test "fails if no array" {
    f() {
        # shellcheck disable=SC2034  # z is used
        local z=0

        array::push z 1 \
        || raise \
        || error \
        || return $?
    }
    run -9 f
    assert_output 'error: z: not a'
}
