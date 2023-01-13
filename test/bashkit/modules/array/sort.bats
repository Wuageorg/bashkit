#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "orders array" {
    f() {
        local -a A=( {1..8} )
        array::sort A
        echo "${A[@]}"
    }
    run -0 f
    assert_output '1 2 3 4 5 6 7 8'

    f() {
        local -a A=( {1..8} )
        array::shuffle A
        array::sort A
        echo "${A[@]}"
    }
    run -0 f
    assert_output '1 2 3 4 5 6 7 8'
}
