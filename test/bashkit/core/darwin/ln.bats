#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

@test "calls gln under the hood" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    source darwin.bash

    touch "${BATS_TMPDIR}/foo"
    rm -f "${BATS_TMPDIR}/bar"

    run -0 ln -T "${BATS_TMPDIR}/foo" "${BATS_TMPDIR}/bar"
    assert_output ''
    refute_output 'ln: illegal option -- T'
}
