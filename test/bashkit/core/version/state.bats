#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source version.bash


# how to find the correct hash for '-':
# in version.bash replace
# ) < <( grep -v '^#@BASHKIT' "${BASH_SOURCE[0]}" ) 2>/dev/null || true
# with
# ) < <( grep -v '^#@BASHKIT' "${BASH_SOURCE[0]}" | tee >(md5sum 1>&2) ) || true
# and the hash will be output
#@BASHKIT_HASHES=( [hashthis]='7f49c14bbba205195ce1b743cb3b2f64' [-]'ff4fec1fc3b57fa569e2b5fed41b57c2' )

@test "contains 'no_hash' if hashing is not available" {
    check::cmd() { return 1; }  # mock to always fail

    version::state

    assert_equal "${#__[@]}" 1
    assert_equal "${__[0]}" 'no_hash'
}

@test "is empty if all hashes matches" {
    printf '%s\n' "realhashthis" > "${BATS_TEST_TMPDIR}/hashthis"

    # redeclare functions here so ${BASH_SOURCE[0]} is this file
    eval "$(declare -fp version__remove)"
    eval "$(declare -fp version::state)"

    # shellcheck disable=SC2154,SC2034 # basedir is fine
    BASHKIT[basedir]="${BATS_TEST_TMPDIR}"

    # mock check command to always succeed
    check::cmd() { return 0; }

    f() {
        version::state
        echo "${#__[@]}"
        if (( ${#__[@]} > 0 )); then
            echo "${__[@]}"
        fi
    }

    run -0 f
    assert_output '0'
}

@test 'fails on bad hash' {
    printf "%s\n" "changed" > "${BATS_TEST_TMPDIR}/hashthis"

    # Re-declare function here so BASH_SOURCE[0] is this file
    eval "$(declare -fp version::state)"

    # shellcheck disable=SC2154,SC2034 # basedir is fine
    BASHKIT[basedir]="${BATS_TEST_TMPDIR}"
    check::cmd() { return 0; }
    f() {
        version::state
        echo "${__[@]}"
    }

    run -0 f
    assert_output -p 'changed_hashthis'
}

@test "version is stateful" {

    # Re-declare function here so ${BASH_SOURCE[0]} is this file
    eval "$(declare -fp version::state)"

    printf "%s\n" 'no' > "${BATS_TEST_TMPDIR}/hashthis"
    # shellcheck disable=SC2154,SC2034 # basedir is fine
    BASHKIT[basedir]="${BATS_TEST_TMPDIR}"
    check::cmd() { return 0; }

    f() {
        version::bashkit
        echo "${__}"
    }

    declare -A BASHKIT_VERSION=( [compat]='24' [date]='3112' [commit]='1829' [branch]='notmain' )

    run -0 f
    assert_output '24.3112.1829.notmain.c42b663'

    # shellcheck disable=SC2034 # BASHKIT_VERSION is used
    declare -A BASHKIT_VERSION=( [compat]='24' [date]='3112' [commit]='1829' [branch]='main' )

    run -0 f
    assert_output '24.3112.1829.c42b663'

    printf "%s\n" 'realhashthis' > "${BATS_TEST_TMPDIR}/hashthis"

    run -0 f
    assert_output '24.3112.1829'
}
