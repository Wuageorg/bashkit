#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

# shellcheck source=/dev/null  # extras in path
source extras.bash


@test "displays progress bar" {
    f() {
        local i
        for (( i=0; i<=100; i++ )); do
            # print progress
            progress "${i}" 10
        done
        printf '\n'
    }

    run -0 f
    assert_output -p '[----------]'
}
