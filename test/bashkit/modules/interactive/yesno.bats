#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source check.bash
source interactive.bash


@test "asks user a question and succeeds if answer is yes" {
    f() {
        LC_MESSAGES=POSIX
        check::cmd yes || fatal
        (yes || true) | interactive::yesno 'are you happy?'
    }
    run -0 f
    assert_output -p 'are you happy? [yes/no]:'
}

@test "asks user a question and fails if answer is no" {
    f() {
        LC_MESSAGES=POSIX
        check::cmd yes
        (yes n || true) | interactive::yesno 'are you tired?'
    }
    run -1 f
    assert_output -p 'are you tired? [yes/no]:'
}

@test "succeeds if default answer is yes" {
    f() {
        LC_MESSAGES=POSIX
        echo -ne '' | interactive::yesno 'are you happy?' y
    }
    run -0 f
    assert_output -p 'are you happy? [YES/no]:'
}

@test "fails if default answer is no" {
    f() {
        LC_MESSAGES=POSIX
        echo -ne '' | interactive::yesno 'are you tired?' n
    }
    run -1 f
    assert_output -p 'are you tired? [yes/NO]:'
}
