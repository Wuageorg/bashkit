#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck disable=SC2030,SC2031  # avoid bats subshell confusion
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "applies fun to array elements" {
    f() {
        local -a A=( {a..e} )
        up() {
           echo "${1^^}"
        }
        array::map A up
        echo "${A[@]}"
    }
    run -0 f
    assert_output 'A B C D E'

    f() {
        local -a A=( {1..8} )
        double() {
           echo "$(( $1 * 2 ))"
        }
        array::map A double
        echo "${A[@]}"
    }
    run -0 f
    assert_output '2 4 6 8 10 12 14 16'
}

@test "succeeds on unset array" {
    f() {
        local -a A  # unset
        double() {
           echo "$(( $1 * 2 ))"
        }
        array::map A double
        echo "${#A[@]}"  # empty
    }
    run -0 f
    assert_output '0'
}

@test "fills array with empty values if fun returns no value" {
    f() {
        local -a A=( {1..8} )
        (( A[0] == 1 ))  # assert witness
        empty() {
           echo ""
        }
        array::map A empty
        (( ${#A[@]} == 8 ))  # assert len
        ! [[ ${A[0]} ]]      # assert empty item
    }
    run -0 f
    assert_output ''

    f() {
        local -a A=( {1..8} )
        (( A[0] == 1 ))  # assert witness
        null() {
           return
        }
        array::map A null
        (( ${#A[@]} == 8 ))  # assert len
        ! [[ ${A[0]} ]]      # assert item empty
    }
    run -0 f
    assert_output  ''
}

@test "succeeds if array is uninitialized" {
    f() {
        local -a A  # uninitialized
        succeed() {
           true
        }
        array::map A succeed
    }

    run -0 f
    assert_output ''
}

@test "fails on bad invocation" {
    f() {
        array::map || fatal
    }
    run -9 f
    assert_output 'fatal: incorrect invocation'

    f() {
        local -a A=( {1..8} )
        (( A[0] == 1 ))  # assert witness
        triple() {
           echo "$(( $1 * 3 ))"
        }
        array::map A triple whatever || fatal
    }
    run -9 f
    assert_output 'fatal: incorrect invocation'
}

@test "fails if fun fails" {
    f() {
        local -a A=( {1..8} )
        fail() {
           false
        }
        array::map A fail || fatal
    }
    run -1 f
    assert_output 'fatal: failed $fun item=1 (1)'
}

@test "fails if not given an array" {
    f() {
        # shellcheck disable=SC2034  # x is used
        x=0
        succeed() {
           true
        }
        array::map x succeed \
        || fatal
    }
    run -9 f
    assert_output 'fatal: x: not a'
}

@test "fails if not given a function" {
    f() {
        local -a A=( {1..8} )
        array::map A true \
        || fatal
    }
    run -9 f
    assert_output 'fatal: fun (true): not f'
}
