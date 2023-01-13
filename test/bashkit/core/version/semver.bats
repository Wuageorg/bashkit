#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source version.bash


@test 'returns BASHKIT_VERSION[@]' {
    # shellcheck disable=SC2034,SC2030 # BASHKIT_VERSION is used in bats test
    local -A BASHKIT_VERSION=( [compat]='24' [date]='3112' [commit]='1829' )

    f() {
        version__semver
        echo "${__}"
    }

    run -0 f
    assert_output '24.3112.1829'
}

#@BASHKIT_VERSION=( [compat]='978' [date]='3112' [commit]='1829' [branch]='main' )

@test 'declares bashkit version at init' {
    # Re-declare function here so ${BASH_SOURCE[0]} is this file
    eval "$(declare -fp version::init)"

    f() {
        version::init
        # shellcheck disable=SC2031 # Declared by init
        echo "${BASHKIT_VERSION[compat]} ${BASHKIT_VERSION[date]} ${BASHKIT_VERSION[commit]} ${BASHKIT_VERSION[branch]}"
    }

    run -0 f
    assert_output '978 3112 1829 main'
}
