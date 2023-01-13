#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

source color.bash


@test "'reset' is \x1b[0m" {
    color::encode; reset="${__}"
    assert_equal "${reset}" '\x1b[0m'
}

@test "'text' is \x1b[39;49m" {
    color::encode text; default="${__}"
    assert_equal "${default}" '\x1b[39;49m'
}

@test "'default text' is \x1b[39;49m" {
    color::encode default text; default="${__}"
    assert_equal "${default}" '\x1b[39;49m'
}

@test "'regular text' is \x1b[0;39;49m" {
    color::encode regular text; regular="${__}"
    assert_equal "${regular}" '\x1b[0;39;49m'
}

@test "'bold bright white text black background' is \x1b[1;97;40m" {
    color::encode bold bright white text black background; boldgray="${__}"
    assert_equal "${boldgray}" '\x1b[1;97;40m'
}

@test "'underlined blinking bold white text red background' is \x1b[4;5;1;37;41m" {
    color::encode underlined blinking bold white text red background; panic="${__}"
    assert_equal "${panic}" '\x1b[4;5;1;37;41m'
}

@test "fails on empty string" {
    color::encode "" || _rc=$?
    assert_equal "${_rc}" 9
    assert_equal "${__}" 'bad color: invalid token'
}

@test "fails on invalid token" {
    color::encode regular foo text || _rc=$?
    assert_equal "${_rc}" 9
    assert_equal "${__}" 'bad color: invalid token'
}

@test "fails on invalid description #1" {
    color::encode white regular bright text || _rc=$?
    assert_equal "${_rc}" 9
    assert_equal "${__}" 'bad color: misplaced bright'
}

@test "fails on invalid description #2" {
    color::encode regular default blue text || _rc=$?
    assert_equal "${_rc}" 9
    assert_equal "${__}" 'bad color: out of range'
}

@test "fails on invalid description #3" {
    color::encode regular yellow blue text || _rc=$?
    assert_equal "${_rc}" 9
    assert_equal "${__}" 'bad color: out of range'
}

@test "fails on invalid description #4" {
    color::encode regular default regular text || _rc=$?
    assert_equal "${_rc}" 9
    assert_equal "${__}" 'bad color: repeating attribute'
}

@test "fails on invalid description #5" {
    color::encode text regular text || _rc=$?
    assert_equal "${_rc}" 9
    assert_equal "${__}" 'bad color: misplaced text'
}

@test "fails on invalid description #6" {
    color::encode text regular background default || _rc=$?
    assert_equal "${_rc}" 9
    assert_equal "${__}" 'bad color: misplaced background'
}
