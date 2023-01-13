#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "displays warning when executed" {
    run -1 trap.bash
    assert_output -p 'is to be sourced not executed!'
}

@test "can be sourced and init on its own" {
    run -0 bash -c '
    source trap.bash
    cleanup "echo bye"
    '
    assert_output -p 'bye'
}
