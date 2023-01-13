#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

# shellcheck source=/dev/null  # extras in path
source extras.bash


@test "returns elapsed milliseconds since EPOCH" {
    f() {
        local bk_ms
        now bk_ms

        local sh_ms

        if [[ ${OSTYPE} = darwin* ]]; then
            if ! command -v gdate &> /dev/null; then
                skip "this darwin hasn't got gdate"
            else
                date() {
                    gdate "$@" 2> /dev/null
                }
            fi
        fi

        sh_ms=$( date +%s%N | cut -b1-13 )

        unset -f date

        delta=$(( sh_ms - bk_ms ))
        printf "%d\n" "${delta}"
    }
    run -0 f
    assert_output -e '^[0-9]{1}$'  # between 0-9 ms


}

@test "is monotonic" {
    f() {
        local -i start
        local -i end
        now start
        usleep 1
        now end
        printf "%d\n" $(( end - start ))
    }
    run -0 f
    assert_output -e '[0-9]+'  # should be between 0-9 ms
}
