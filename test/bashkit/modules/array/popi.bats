#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "pops arbitrary array item" {
    f(){
        local -a A=( {1..11} )
        local item
        array::popi A 5 item
        (( item == 6 )) \
        || exit 1
    }
    run -0 f
    assert_output ''
}

@test "fails if empty arrays" {
    f() {
        # shellcheck disable=SC2030  # A is fine
        local -a A=()  # empty
        local item
        array::popi A 1 item \
        || raise \
        || error \
        || return $?
    }
    run -9 f
    assert_output 'error: empty array'
}

@test "fails on uninitialized arrays" {
    f() {
        # shellcheck disable=SC2034  # A is fine
        local -a A  # uninitialized
        local item
        array::popi A 1 item \
        || raise \
        || error \
        || return $?
    }
    run -9 f
    assert_output 'error: A: not set'
}

@test "fails if no array" {
    f() {
        # shellcheck disable=SC2034  # z is used
        local z=0
        local item

        array::popi z 1 item \
        || raise \
        || error \
        || return $?
    }
    run -9 f
    assert_output 'error: z: not a'
}
