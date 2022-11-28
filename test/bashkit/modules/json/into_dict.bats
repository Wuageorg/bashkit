#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

# shellcheck source=/dev/null  # json in path
source json.bash && json::init


@test "loads into dict" {
    local -A DICT
    local json='{"a": 3, "b": "x", "3": "hello", "7": {"sub": "subobject and ", "array": [3, true, "x"] }}'

    json::into_dict DICT <<< "${json}"

    assert_equal "${#DICT[@]}" 4
    assert_equal "${DICT[a]}" 3
    assert_equal "${DICT[b]}" 'x'
    assert_equal "${DICT[3]}" 'hello'
    assert_equal "${DICT[7]}" '{"sub":"subobject and ","array":[3,true,"x"]}'
}
