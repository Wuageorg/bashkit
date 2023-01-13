#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "explicitly handles error" {
    run -0 bash -c '
    source bashkit.bash
    error::custom FOO 1  # try reading $__ for more
    error::custom BAR 2
    error::custom BAZ 3

    (( ${E_FOO} != 1 ))  # assert, try error::whatis "E_FOO" for more

    fail() (  # subshell
        local rc; rc=$(( ( RANDOM % 3 ) + 1 ))  # 1 <= rc <= 3
        case "${rc}" in
           1) exit "${E_FOO}";;
           2) exit "${E_BAR}";;
           3) exit "${E_BAZ}";;
           *) exit 1;;  # unreachable
        esac
    )

    # common error handling pattern
    fail || {
        catch rc  # put error code in $rc and proceed
        case "${rc}" in
           ${E_FOO}) printf "%s\n" "handling E_FOO";;
           ${E_BAR}) printf "%s\n" "handling E_BAR";;
           ${E_BAZ}) printf "%s\n" "handling E_BAZ";;
           *) printf "unreachable\n";;
        esac
    }
    '
    assert_output -e 'handling (E_FOO|E_BAR|E_BAZ)'
    refute_output 'unreachable'
}
