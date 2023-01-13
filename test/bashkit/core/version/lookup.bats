#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source version.bash


@test 'lookup variable within file' {
    printf "%s\n" \
        "Lorem ipsum dolor sit amet," \
        "consectetur adipiscing elit," \
        "sed do eiusmod tempor incididunt" \
        "ut labore et dolore magna aliqua." \
        "" \
        "Ut enim ad minim veniam, quis nostrud" \
        "#@LOOKUPtrap" \
        "exercitation ullamco laboris nisi ut aliquip" \
        "#@=" \
        "#@=LOOKUP" \
        "ex ea commodo con#@sequat. Duis aute irure dolor" \
        "in reprehenderit in voluptate #@" \
        "#@" \
        "velit esse cillum dolore eu fugiat nulla" \
        "#@LOOKUP=found" \
        "pariatur. Excepteur sint occaecat cupidatat" \
        "non proident, sunt in culpa qui officia deserunt" \
        "mollit anim id est laborum." \
    > "${BATS_TEST_TMPDIR}/testlookup"

    version__lookup "LOOKUP" "${BATS_TEST_TMPDIR}/testlookup"
    assert_equal "${__}" 'LOOKUP=found'
}
