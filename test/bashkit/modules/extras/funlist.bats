#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

# shellcheck source=/dev/null  # extras in path
source extras.bash


@test "list functions" {
    f() {
        funlist
    }
    run -0 f
    assert_output -p 'funlist'
}
