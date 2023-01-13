#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "intersects arrays" {
    f() {
        local -a A=( {1..8} )
        local -a B=( {4..12} )
        array::inter A B
        echo "${A[@]}"
    }

    run -0 f
    assert_output '4 5 6 7 8'
}

@test "is identity when identical arrays" {
    f() {
        local -a A=( {1..8} )
        local -a B=( {1..8} )
        array::inter A B
        echo "${A[@]}"
    }

    run -0 f
    assert_output '1 2 3 4 5 6 7 8'
}

@test "succeeds even if empty intersection" {
    f() {
        local -a A=( {1..8} )
        # shellcheck disable=SC2034 # B is used
        local -a B=( {9..12} )
        array::inter A B
        echo "${#A[@]}"  # 0, empty intersection
    }

    run -0 f
    assert_output '0'
}
