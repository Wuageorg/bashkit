#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck disable=SC2030,SC2031  # avoid bats subshell confusion
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "aggregates array elements" {
    f() {
        local -a A=( {1..8} )
        add() { echo $(( $1 + $2 )); }
        acc=0
        array::reduce A add acc
        echo "${acc}"
    }
    run -0 f
    assert_output 36

    f() {
        local -a A=( {a..e} )
        add() { echo "$1$2"; }
        acc=""
        array::reduce A add acc
        echo "${acc}"
    }
    run -0 f
    assert_output 'abcde'
}

@test "succeeds on uninitialized array" {
    f() {
        local -a A  # uninitialized
        add() { echo "$1$2"; }
        acc=""
        array::reduce A add acc
        echo "${#A[@]} ${#acc}"  # empty
    }
    run -0 f
    assert_output '0 0'
}
