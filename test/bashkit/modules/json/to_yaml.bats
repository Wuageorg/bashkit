#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck disable=SC2154  # vars are assigned

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"
load "${BATS_TEST_DIRNAME%test*}/test/bashkit/modules/json/helper"

bashkit_mock

# shellcheck source=/dev/null  # json in path
source json.bash


@test "converts json to yaml" {
    python3 -c "import yaml" 2> /dev/null \
    || skip "python3 yaml not found"

    f() {
        printf '%s\n' "${json}" | json::to_yaml /dev/stdin
    }

    run -0 f
    assert_output "${yaml}"
}
