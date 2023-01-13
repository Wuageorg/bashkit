#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "builds dict from key/value arrays" {
    f() {
        # shellcheck disable=SC2034 # D is used
        local -A D
        # shellcheck disable=SC2034 # K is used
        local -a K=( {a..e} )
        # shellcheck disable=SC2034 # B is used
        local -a V=( {1..8} )
        array::zip D K V
        # shellcheck disable=SC2034 # D is used
        declare -p D
    }
    run -0 f
    assert_output -p 'D=([e]="5" [d]="4" [c]="3" [b]="2" [a]="1" )'
}
