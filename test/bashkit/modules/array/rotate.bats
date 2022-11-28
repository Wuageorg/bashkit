#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "-n cycles array toward left" {
    f() {
        local -a A=( {1..8} )
        array::rotate A -10
        echo "${A[@]}"
    }
    run -0 f
    assert_output '3 4 5 6 7 8 1 2'
}

@test "+n cycles array toward right" {
    f() {
        local -a A=( {1..8} )
        array::rotate A 11
        echo "${A[@]}"
    }
    run -0 f
    assert_output '6 7 8 1 2 3 4 5'
}

@test "0 does nothing" {
    f() {
        local -a A=( {1..8} )
        array::rotate A 0
        echo "${A[@]}"
    }
    run -0 f
    assert_output '1 2 3 4 5 6 7 8'
}
