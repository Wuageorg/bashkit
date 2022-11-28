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


@test "defines \$BASHKIT and \$SCRIPT" {
    run -0 bash -c '
    unset BASHKIT SCRIPT
    source bashkit.bash
    echo ${BASHKIT[*]}
    echo ${SCRIPT[*]}
    '
    assert_output -e '(bashkit.)?bash'
}

@test "unsets extdebug, sets functrace, pipefail, nounset" {
    run -0 bash -c '
    source bashkit.bash
    shopt extdebug 2>&1 \
    || true
    echo "${SHELLOPTS}" | grep -E "(functrace|pipefail|nounset)"
    '
    assert_output -e 'off|:(functrace|pipefail|nounset)'
    refute_output -p 'on'
}
