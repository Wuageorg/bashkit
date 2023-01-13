#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "dedupes array" {
    f() {
        local -a A=( {1..8} )
        A+=( "${A[@]}" )  # duplicate array items
        len=${#A[@]}  # should be 16
        array::uniq A
        (( len / 2 == ${#A[@]} ))  # should be 16/2 == 8
        echo "${A[@]}"
    }
    run -0 f
    assert_output '8 7 6 5 4 3 2 1'  # deduped but lost order!
}
