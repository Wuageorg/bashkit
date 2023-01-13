#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck disable=SC2034  # vars are used
# shellcheck disable=SC2030,SC2031  # vars are fine even from subshell
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source check.bash


@test "validates integer" {
    local -i intvar

    check::vartype i intvar
}

@test "validates set integer" {
    local -i intvar=27

    check::vartype i intvar
}

@test "validates set string" {
    strvar='foo'
    check::vartype s strvar
}

@test "validates array" {
    local -a ARR

    check::vartype a ARR
}

@test "validates set array" {
    local -a ARR=( 1 2 3 )

    check::vartype as ARR
}

@test "validates function" {
    foo() { true; }
    bar=foo

    check::vartype f bar
}

@test "validates dict" {
    local -A DICT

    check::vartype A DICT
}

@test "validates set dict" {
    local -A DICT=( [a]=1 [b]=2 [c]=3 )

    check::vartype As DICT
}

@test "validates exported" {
    local -A DICT
    export DICT

    check::vartype x DICT
}

@test "validates exported set" {
    local -A DICT=( [a]=1 [b]=2 [c]=3 )
    export DICT

    check::vartype Ax DICT
}

@test "validates refname" {
    local -n __ref
    check::vartype n __ref
}

@test "validates through refname" {
    local -i intvar
    local -n __ref=intvar

    check::vartype i __ref
}

@test "validates set through refname" {
    local -i intvar=27
    local -n __ref=intvar

    check::vartype is __ref
}

@test "validates l, u, r, t attributes" {
    for attr in l u t r; do  # read-only is last on purpose
        unset var;
        local -"${attr}" var='foo'

        check::vartype "${attr}" var
        assert_equal $? 0
    done
}

@test "fails if no var" {
    f() {
        check::vartype is
    }
    run -9 f
    assert_output 'fatal: incorrect invocation'
}

@test "fails if undeclared" {
    check::vartype a undeclared \
    || _rc=$?

    assert_equal "${_rc}" 9
    assert_equal "${__}" 'undeclared: not found'
}

@test "fails if wrong type" {
    local -i intvar
    check::vartype a intvar \
    || _rc=$?  # not an array

    assert_equal "${_rc}" 9
    assert_equal "${__}" "intvar: not a"
}

@test "fails if wrong type through refname" {
    local -i intvar
    local -n __ref=intvar
    check::vartype a __ref \
    || _rc=$?  # not an array

    assert_equal "${_rc}" 9
    assert_equal "${__}" "intvar: not a"
}

@test "fails if not set" {
    local -i intvar  # not set
    check::vartype is intvar \
    || _rc=$?

    assert_equal "${_rc}" 9
    assert_equal "${__}" "intvar: not set"
}

@test "fails if attr not set" {
    local -i intvar=0
    check::vartype ils intvar \
    || _rc=$?

    assert_equal "${_rc}" "9"
    assert_equal "${__}" "intvar: not l"
}
