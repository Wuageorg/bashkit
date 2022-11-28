#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

@test "calls gnu date under the hood" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    source darwin.bash

    run -0 date '+%s%3N'
    assert_output -e '^[0-9]{13}$'
}
