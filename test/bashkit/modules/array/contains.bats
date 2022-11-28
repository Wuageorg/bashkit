#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "finds item in array" {
    local -a A=( {1..4} )

    local i
    for((i=1; i<5; i++)); do
        array::contains A "${i}"
    done

    assert_equal $? 0
}

@test "gives item index as by-product" {
    local -a A=( {1..4} )

    local i
    local -i idx
    for((i=1; i<5; i++)); do
        array::contains A "${i}"; idx=${__}
        (( idx == A[idx] - 1 )) \
        || fatal 'no valid index'
    done

    assert_equal $? 0
}

@test "does not modify array" {
    f() {
        local -a A=( {1..4} )

        local i
        local -i idx
        for((i=1; i<5; i++)); do
           array::contains A "${i}" && idx=${__}
           (( idx == A[idx] - 1 )) \
           || fatal 'no valid index'
        done
        echo "${A[@]}"
    }
    run -0 f
    assert_output '1 2 3 4'

    f() {
        local -a A=( {1..4} )
        array::contains A 5 \
        || true  # fails but recovers
        echo "${A[@]}"
    }
    run -0 f
    assert_output '1 2 3 4'
}

@test "fails on bad invocation" {
    f() {
        array::contains \
        || fatal  # fail!
    }
    run -9 f
    assert_output 'fatal: incorrect invocation'

    f() {
        local -a A=( {1..4} )
        array::contains A 5 whatever and more \
        || fatal  # fails!
    }
    run -9 f
    assert_output 'fatal: incorrect invocation'
}

@test "fails when item not found" {
    f() {
        local -a A=( {1..4} )
        array::contains A 5 \
        || fatal # fails!
    }
    run -1 f
    assert_output 'fatal: 5 not found'
}

@test "fails on empty array" {
    f() {
        local -a array=()  # empty
        array::contains array 5 \
        || fatal # fails!
    }
    run -1 f
    assert_output 'fatal: 5 not found'
}

@test "fails on unassigned array" {
    f() {
        # shellcheck disable=SC2034  # array is used
        local -a array
        array::contains array 5 \
        || fatal  # fails!
    }
    run -9 f
    assert_output 'fatal: array: not set'
}

@test "fails when not applied on array" {
    f() {
        # shellcheck disable=SC2034  # x is used
        x=0
        array::contains x 0 \
        || fatal  # fails!
    }
    run -9 f
    assert_output 'fatal: x: not a'
}
