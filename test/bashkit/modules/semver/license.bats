#	"bats" test script for semver 2.0.0 specification (https://semver.org/)
#

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

bats_require_minimum_version 1.5.0
SRC_ROOT=${BATS_TEST_FILENAME%/test*}

@test "ensure SPDX tag is present" {
    run grep -E '^# SPDX-License-Identifier: Apache-2.0$' "${SRC_ROOT}/modules/semver.bash"
    (( status == 0 ))
}
