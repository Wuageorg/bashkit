#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

setup() {
    BASHKIT=${BATS_TEST_DIRNAME%test*}
    load "${BASHKIT}/test/helper/common-setup"
    _common_setup
}

@test "cleanup() execute callbacks in LIFO when script exit" {
    run -0 bash -c '
    source bashkit.bash

    module::init() {
        cleanup "echo bye1"
        cleanup "echo bye2"
    }
    module::init
    '
    assert_output -e 'bye2[[:space:]]+bye1'
}
