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


@test "converts toml to json" {
    python3 -c "import toml" 2> /dev/null \
    || skip "python3 toml not found"

    f() {
        printf '%s\n' "${toml}" | json::from_toml /dev/stdin | jq -S --indent 4 .
    }

    run -0 f
    assert_output "${json}"
}
