#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

setup() {
    BASHKIT=${BATS_TEST_DIRNAME%test*}
    load "${BASHKIT}/test/helper/common-setup"
    _common_setup
}

@test "displays a consistent help and usage" {
    # help and usage are undefined
    run -2 bash -c '
    source bashkit.bash 2>&1
    bashkit::help
    '
    assert_output -p 'Usage: undefined usage'
    assert_output -p 'undefined help'

    # help and usage are defined
    run -2 bash -c '
    source bashkit.bash 2>&1
    __usage="foo"
    __help="bar"
    bashkit::help
    '
    assert_output -p 'Usage: foo'
    assert_output -p 'bar'
}
