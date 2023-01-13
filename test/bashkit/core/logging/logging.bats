#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "displays warning when executed" {
    run -1 logging.bash
    assert_output -p 'is to be sourced not executed!'
}

@test "can be sourced and initialized on its own" {
    run -0 bash -c '
    source logging.bash
    logging::init
    '
    assert_output ''
}

@test "default loglevel is 6 (info)" {
    run -0 bash -c '
    source logging.bash
    logging::init
    logging::level
    '
    assert_output '6'
}
