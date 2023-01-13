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
if [[ ${OSTYPE} = darwin* ]]; then
    source darwin.bash
fi


@test "converts group name to gid" {
    group=$( id -gn )
    gid=$( id -g )
    assert_equal "$( perms::gid "${group}" )" "${gid}"
}
