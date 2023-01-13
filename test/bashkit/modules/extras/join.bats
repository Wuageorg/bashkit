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


@test "joins args" {
    run -0 join , a b c d
    assert_output 'a,b,c,d'
}

@test "joins correctly a single arg" {
    run -0 join , a
    assert_output 'a'
}

@test "uses one char separator only" {
    run -0 join ', this is discarded' a b c d
    assert_output 'a,b,c,d'
}

@test "returns nothing if no arg" {
    run -0 join ,
    assert_output ''
}
