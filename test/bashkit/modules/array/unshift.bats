#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "adds a unique element as first element" {
    f() {
        local -a A=( {2..8} )
        array::unshift A 1
        echo "${A[@]}"
    }
    run -0 f
    assert_output '1 2 3 4 5 6 7 8'
}

@test "adds multiple elements as first elements" {
    f() {
        local -a A=( {4..8} )
        array::unshift A 1 2 3
        echo "${A[@]}"
    }
    run -0 f
    assert_output '1 2 3 4 5 6 7 8'
}

@test "works on empty array" {
    f() {
        local -a A=( )
        array::unshift A 1 2 3 4 5 6 7 8
        echo "${A[@]}"
    }
    run -0 f
    assert_output '1 2 3 4 5 6 7 8'
}

@test "fails with no items" {
    f() {
        local -a A=( {1..8} )
        array::unshift A
        echo "${A[@]}"
    }
    run -9 f
    assert_output 'fatal: incorrect invocation'
}
