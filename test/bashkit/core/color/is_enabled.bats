#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

source color.bash


@test "colors are disabled during tests" {
    color::is_enabled || _rc=$?
    assert_equal "${_rc}" 1
}
