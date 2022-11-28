#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source check.bash
source perms.bash


@test "converts user to uid" {
    user=$( id -un )
    uid=$( id -u )
    assert_equal "$( perms::uid "${user}" )" "${uid}"
}
