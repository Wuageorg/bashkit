#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source error.bash && error::init


@test "registers custom error and acks in \$__" {
    f() {
        error::custom FOO 1
        echo "${__}"
        echo "${E_FOO}"
    }
    run -0 f
    assert_output -p 'E_FOO=33'
    assert_output -p '33'
}

@test "zero is not a valid errcode" {
    error::custom FOO 0 || _rc=$?

    assert_equal "${_rc}" 9
    assert_equal "${__}" 'invalid errcode'
}
