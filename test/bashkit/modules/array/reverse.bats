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


@test "reverses array" {
    f() {
        local -a A=( {1..11} )
        array::reverse A
        echo "${A[@]}"
    }
    run -0 f
    assert_output '11 10 9 8 7 6 5 4 3 2 1'
}
