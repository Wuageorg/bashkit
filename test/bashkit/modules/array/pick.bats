#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source array.bash


@test "picks array item at random" {
    f(){
        local -a A=( {1..11} )
        item=$( array::pick A )
        if ! [[ ${A[*]} = *${item}* ]]; then
            exit 1
        fi
    }
    run -0 f
    assert_output ''
}

@test "fails if empty arrays" {
    f() {
        local item

        # shellcheck disable=SC2030  # A is fine
        local -a A=()  # empty
        item=$(
            array::pick A \
            || {
                resume printf '%s' "${__}"
                raise
            }
        ) \
        || raise "${E_PARAM_ERR}" "${item}" \
        || error \
        || return $?

        if ! [[ ${A[*]} = *${item}* ]]; then
            exit 1
        fi
    }
    run -9 f
    assert_output 'error: empty array'
}

@test "fails on uninitialized arrays" {
    f() {
        local item

        # shellcheck disable=SC2030  # A is fine
        local -a A  # uninitialized
        item=$(
            array::pick A \
            || {
                resume printf '%s' "${__}"
                raise
            }
        ) \
        || raise "${E_PARAM_ERR}" "${item}" \
        || error \
        || return $?

        # shellcheck disable=SC2031  # A is fine
        if ! [[ ${A[*]} = *${item}* ]]; then
            exit 1
        fi
    }
    run -9 f
    assert_output 'error: A: not set'
}

@test "fails if no array" {
    f() {
        # shellcheck disable=SC2034  # z is used
        local z=0

        item=$(
            array::pick z \
            || {
                resume printf '%s' "${__}"
                raise
            }
        ) \
        || raise "${E_PARAM_ERR}" "${item}" \
        || error \
        || return $?

        # shellcheck disable=SC2031  # A is fine
        if ! [[ ${A[*]} = *item* ]]; then
            exit 1
        fi
    }
    run -9 f
    assert_output 'error: z: not a'
}
