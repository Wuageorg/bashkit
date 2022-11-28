#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "removes the first element" {
    f() {
        local x=0
        local -a A=( {1..8} )
        array::shift A x
        (( x == 1 )) && echo "${A[@]}"
    }
    run -0 f
    assert_output '2 3 4 5 6 7 8'
}

@test "works on singleton" {
    f() {
        local x=0
        local -a A=( 1 )
        array::shift A x
        (( x == 1 && ${#A[@]} == 0 )) \
        && echo pass
    }
    run -0 f
    assert_output 'pass'
}

@test "fails on empty array" {
    f() {
        local x
        local -a A=()
        array::shift A x
    }
    run -9 f
    assert_output ''
}
