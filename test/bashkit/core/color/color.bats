#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "displays warning when executed" {
    run -1 color.bash
    assert_output -p 'is to be sourced not executed!'
}

@test "can be sourced and used on its own" {
    # shellcheck source=/dev/null
    source color.bash
    color::init;

    _rc=0
    color::encode red text || _rc=$?
    assert_equal "${_rc}" 0
    assert_equal "${__}" '\x1b[31;49m'
}
