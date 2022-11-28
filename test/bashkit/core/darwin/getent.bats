#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

if [[ ${OSTYPE} == 'darwin'* ]]; then
    source darwin.bash
fi


@test "returns user data" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    f() {
        getent passwd root
    }
    run -0 f
    assert_output 'root:x:0:0:System Administrator:/var/root:/bin/sh'
}

@test "returns group data" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    f() {
        getent group staff
    }
    run -0 f
    assert_output 'staff:x:20:'
}

@test "returns host data" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    f() {
        getent hosts localhost
    }
    run -0 f
    assert_output -e 'localhost (127\.0\.0\.1|\:\:1)'
}

@test "fails with 2 if inexistent user" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    f() {
        getent passwd "non_existent_user_${RANDOM}"
    }
    run -2 f
    assert_output 'error: can not dscl -read'
}

@test "fails with 2 if inexistent group" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    f() {
        getent group "non_existent_group_${RANDOM}"
    }
    run -2 f
    assert_output 'error: can not dscl -read'
}

@test "fails with 2 if inexistent host" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    f() {
        getent hosts "non_existent_host_${RANDOM}"
    }
    run -2 f
    assert_output 'error: host not found'
}

@test "fails with 1 if unknown database" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    f() {
        getent "non_existent_db_${RANDOM}" foo
    }
    run -1 f
    assert_output 'error: database unknown'
}

@test "fails with 3 if user enumeration" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    f() {
        getent passwd
    }
    run -3 f
    assert_output 'error: listing not supported'
}

@test "fails with 3 if group enumeration" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    f() {
        getent group
    }
    run -3 f
    assert_output 'error: listing not supported'
}

@test "fails with 3 if host enumeration" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    run -3 getent hosts
    assert_output 'error: listing not supported'
}

@test "joins args" {
    if [[ ${OSTYPE} != 'darwin'* ]]; then
        skip "this test is for darwin"
    fi

    joined=$( getent__join "," "a" "b" "c" "d" )
    assert_equal "${joined}" 'a,b,c,d'

    # single arg
    joined=$( getent__join "," "a" )
    assert_equal "${joined}" 'a'

    # discard everything but first char of sep
    joined=$( getent__join ", this is discarded" "a" "b" "c" "d" )
    assert_equal "${joined}" 'a,b,c,d'

    # nop if no arg
    _rc=0 joined=''
    joined=$( getent__join "," ) || _rc=$?
    assert_equal "${_rc}" 0
    assert_equal "${joined}" ''
}
