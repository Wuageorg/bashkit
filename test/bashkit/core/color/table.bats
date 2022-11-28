#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

source color.bash


@test "'reset' is \x1b[0m" {
    color::encode
    # shellcheck disable=SC2030  # reset is fine
    reset="${__}"
    assert_equal "${reset}" '\x1b[0m'
}

@test "converts color description table to ANSI code table" {
    local -A COLPAL=(  # color palette
        [panic]="underlined blinking bold white text red background"
        [alert]="bold white text red background"
        [crit]="bold red text"
        [error]="red text"
        [warn]="yellow text"
        [note]="blue text"
        [info]="green text"
        [debug]="magenta text"
        [reset]="reset"
    )

    color::table COLPAL

    assert_equal "${COLPAL[panic]}" '\x1b[4;5;1;37;41m'
    assert_equal "${COLPAL[alert]}" '\x1b[1;37;41m'
    assert_equal "${COLPAL[crit]}"  '\x1b[1;31;49m'
    assert_equal "${COLPAL[error]}" '\x1b[31;49m'
    assert_equal "${COLPAL[warn]}"  '\x1b[33;49m'
    assert_equal "${COLPAL[note]}"  '\x1b[34;49m'
    assert_equal "${COLPAL[info]}"  '\x1b[32;49m'
    assert_equal "${COLPAL[debug]}" '\x1b[35;49m'
    # shellcheck disable=SC2031  # reset is fine
    assert_equal "${COLPAL[reset]}" '\x1b[0m'
}
