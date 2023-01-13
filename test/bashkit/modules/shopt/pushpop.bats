#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null  # files are in source path


load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

@test "saves/restores bash options" {
    f() {
        source shopt.bash
        shopt::init

        shopt::push
        shopt -s extdebug
        shopt -p extdebug
        shopt::pop

        shopt -p extdebug
    }
    run -1 f
    assert_output -e 'shopt -s extdebug[[:space:]]+shopt -u extdebug'
}
