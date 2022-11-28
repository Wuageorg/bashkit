#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source error.bash && error::init


@test "classifies error" {
    run -0 error::class E_FAILURE
    assert_output -p 'bash'

    run -0 error::class E_SUCCESS
    assert_output -p 'bash'

    run -0 error::class E_PARAM_ERR
    assert_output -p 'bashkit'

    run -0 error::class E_CUSTOM
    assert_output -p 'custom'

    run -0 error::class E_SIGWAITING
    assert_output -p 'signal'
}

@test "private log2 fails on 0" {
    run -1 class__log2 0
    assert_output ''
}

@test "private log2 is correct for 32 random numbers in [1-32767]" {
    command -v bc &>/dev/null || skip 'need bc'

    f() {
        local i
        for(( i=0; i<32; i++ )) do
            n=$((1 + RANDOM % 32767))  # random in [1-32767]
            bclog2=$( bc -l <<< "l(${n})/l(2)" )
            bclog2=${bclog2%.*}  # integer part
            class__log2 "${n}"
            bklog2=${__}
            (( bclog2 == bklog2 )) || exit 1
        done
        printf "passed\n"
    }
    run -0 f
    assert_output 'passed'
}
