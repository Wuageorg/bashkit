#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "scrambles array" {
    f() {
        local -a A=( {1..8} )
        array::shuffle A
        echo "${A[@]}"
    }
    run -0 f
    assert_output -e "^([1-8]( )?){8}$"  # match any permutation of 1 to 8...
    refute_output '1 2 3 4 5 6 7 8'  # ...except this one
}
