#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null  # files are in source path

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"
load "${BATS_TEST_DIRNAME%test*}/test/bashkit/modules/readlinkf/helper"

bashkit_mock

source readlinkf.bash

@test "displays warning when executed" {
    run -1 readlinkf.bash
    assert_output -p 'is to be sourced not executed!'
}

@test "passes original path tests" {
    run -0 pathes | tests  # defined in ./helper.bash
    assert_output ''
}

@test "preserves variables" {
    f() {
        cd /bin
        cd /dev
        CDPATH=/usr

        # shellcheck disable=SC2034  # link is unused on purpose
        link=$(/usr/bin/env readlink -f /RLF-BASE/DIR/LINK3 || true) > /dev/null
        [[ ${PWD} = /dev ]]
        [[ "${OLDPWD}" = /bin ]]
        [[ "${CDPATH}" = /usr ]]

        # shellcheck disable=SC2034  # link is unused on purpose
        link=$(readlinkf /RLF-BASE/DIR/LINK3 || true) > /dev/null
        [[ "$PWD" = /dev ]]
        [[ "${OLDPWD}" = /bin ]]
        [[ "${CDPATH}" = /usr ]]
    }
    run -0 f
    assert_output ''
}
