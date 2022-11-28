#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "succeeds when trap is enabled" {
    is_bashand && skip 'need bash';

    run -0 bash -c '
    source bashkit.bash
    errcode::trap
    errcode::trap status  # equivalent
    '
    assert_output ''
}

@test "warns and debug message when trap is disabled" {
    run -0 bash -c '
    LOGLEVEL=7
    source bashkit.bash
    errcode::trap disable
    '
    assert_log 'warn' 'errcode::trap' '!!! disabling errcode trap is not advised !!!'
    assert_log 'debug' 'errcode::trap' 'disabling errcode trap may result in non obvious bad script side effects'
}

@test "fails when trap is disabled" {
    run -0 bash -c '
    source bashkit.bash
    errcode::trap disable
    errcode::trap || catch rc1
    errcode::trap status || catch rc2
    (( rc1 * rc2 == 1 ))
    '
    assert_log 'warn' 'errcode::trap' '!!! disabling errcode trap is not advised !!!'
}

@test "enables trap on demand" {
    is_bashand && skip 'need bash';

    run -0 bash -c '
    source bashkit.bash
    errcode::trap disable
    errcode::trap enable
    errcode::trap status  # 0 when enabled
    '
    assert_log 'warn' 'errcode::trap' '!!! disabling errcode trap is not advised !!!'
}

@test "prevents trap to hook custom callback on DEBUG" {
    is_bashand && skip 'need bash';

    run -2 bash -c \
        "source bashkit.bash; trap 'echo debug trapped!' DEBUG;"
    assert_log 'fatal' 'trap' 'trap on debug is reserved to bashkit errcode'
}

@test "allows trap to hook custom callback on other signals" {
    run -129 timeout 2s bash -c '
    source bashkit.bash
    child() {
        hup() { echo "hup!"; exit "${E_SIGHUP}"; }
        trap hup SIGHUP
        for((;;)) { sleep 0; }  # idle
    }
    child &
    cpid="${!}"

    sleep 0

    echo "hupping"
    kill -HUP "${cpid}"

    wait "${cpid}" 2> /dev/null
    '
    assert_output -e '(hupping|hup!)'
}

@test "custom trap on DEBUG may be forced (not recommended)" {
    run -0 bash -c "
    source bashkit.bash
    builtin trap 'echo debug trapped!' DEBUG
    "
    assert_output -e 'debug trapped!'
}
