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


@test "converts -rw-r--r-- to '0644'" {
    assert_equal "$( perms::mode "-rw-r--r--" )" '0644'
}
