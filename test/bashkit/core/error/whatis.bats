#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source error.bash && error::init


@test "resolves error name to code and conversly" {
    run -0 error::whatis E_SIGWAITING
    assert_output -p '160'

    run -0 error::whatis 160
    assert_output -p 'E_SIGWAITING'
}
