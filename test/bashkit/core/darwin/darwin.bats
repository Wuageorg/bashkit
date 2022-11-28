#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

@test "displays warning when executed" {
    # shellcheck source=/dev/null
    run -1 darwin.bash
    assert_output -p 'is to be sourced not executed!'
}

@test "displays warning when not on darwin" {
    if [[ "${OSTYPE}" == 'darwin'* ]]; then
        skip "this test is not for darwin"
    fi

    # shellcheck source=/dev/null
    run -1 source darwin.bash
    assert_output -p 'darwin.bash is NOT for '
}
