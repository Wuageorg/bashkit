#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source error.bash && error::init


@test "lists (all) errors on demand" {
    run -0 error::list
    assert_output -p 'E_SIGWAITING=160'  # there is more

    run -0 error::list all
    assert_output -p 'E_SIGWAITING=160' # there is more

    run -0 error::list bash
    assert_output -p 'E_TIMEOUT=124' # there is more

    run -0 error::list bashkit
    assert_output -p 'E_PARAM_ERR=9' # there is more

    run -0 error::list custom
    assert_output -p 'E_CUSTOM=32'

    run -0 error::list signal
    assert_output -p 'E_SIGWAITING=160'
}
