#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

# shellcheck source=/dev/null  # json in path
source json.bash && json::init


@test "loads into array" {
    local -a ARRAY
    local json='["a", "b", 3, 7]'

    json::into_array ARRAY <<< "${json}"

    assert_equal "${#ARRAY[@]}" 4
    assert_equal "${ARRAY[0]}" 'a'
    assert_equal "${ARRAY[1]}" 'b'
    assert_equal "${ARRAY[2]}" 3
    assert_equal "${ARRAY[3]}" 7
}
