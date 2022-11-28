#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck disable=SC2030,SC2031  # vars are fine even from subshell
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source check.bash


@test "succeeds if directory exists" {
    local _rc=0 __=''
    # directory pre-exists
    check::dir "${BATS_TEST_DIRNAME}" \
    || _rc=$?

    assert_equal "${_rc}" 0
    assert_equal "${__}" ''
}

@test "makes inexistent directory" {
    debug() { ____log_mock "$@"; };

    f() {
        TMPDIR=$( mktemp -u "${BATS_TEST_TMPDIR}/XXXXXX" )
        check::dir "${TMPDIR}"
    }
    run -0 f
    assert_output -e "debug: making ${BATS_TEST_TMPDIR}"

    unset -f debug
}

@test "nop if bad invocation" {
    local _rc=0 __=''

    check::dir \
    || _rc=$?

    assert_equal "${_rc}" 0
    assert_equal "${__}" ''
}

@test "fails and records failure reason when unable to make dir" {
    # mock mkdir
    mkdir() {
        echo "mkdir: ${*}: permission denied" >&2
        return 1
    }

    LC_ALL=C

    check::dir /foo/bar || _rc=$?

    assert_equal "${_rc}" 1
    assert_equal "${__[2]}" 'check::dir'

    match=passed
    rex='mkdir:.* .*/foo.*: .*'
    [[ ${__} =~ ${rex} ]] \
    || match=failed

    assert_equal "${match}" 'passed'
}
