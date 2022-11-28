#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "builds array from split string" {
    f() {
        local -a A
        array::split A 'apples,oranges,pears,grapes' ','
        echo "${A[@]}"
    }
    run -0 f
    assert_output -e 'apples[[:space:]]oranges[[:space:]]pears[[:space:]]grapes'
}
