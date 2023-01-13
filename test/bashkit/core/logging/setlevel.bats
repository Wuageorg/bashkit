#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck disable=SC2154 # __LOGGING[level] exists
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source logging.bash


@test "defaults to level 6" {
    f() {
        (exit 0) && info 'passed #0'

        logging::setlevel
        (exit 1) || info 'passed #1'

        logging::setlevel 'default'
        (exit 2) || info 'passed #2'

        logging::setlevel 'badarg'
        (exit 3) || info 'passed #3'

        logging::setlevel 42
        (exit 4) || info 'passed #4'
    }
    run -0 f

    assert_log 'info' 'f' 'passed #0'
    assert_log 'info' 'f' 'passed #1'
    assert_log 'info' 'f' 'passed #2'
    assert_log 'info' 'f' 'passed #3'
    assert_log 'info' 'f' 'passed #4'
}

@test "sets an arbitrary level" {
    # set and assert all possible levels using their numbers and names
    f() {
        local -a LEVELS=( panic alert crit error warn note info debug )
        for i in "${!LEVELS[@]}"; do
            logging::setlevel "${i}"  # set by number: 0..7
            (( __LOGGING[level] == i )) || exit "$(( 10 + i ))"  # assert or exit 10..17

            logging::setlevel "${LEVELS[i]}" # set by name: panic, alert, ..., debug
            (( __LOGGING[level] == i )) || exit "$(( 20 + i ))"  # assert or exit 20..27
        done
        printf 'passed\n'
    }
    run -0 f
    assert_output 'passed'
}
