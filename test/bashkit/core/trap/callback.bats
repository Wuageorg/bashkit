#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "registers callbacks on arbitrary signal" {
    run -129 timeout 8s bash -c \
        '
        source bashkit.bash
        child() {
           hup() { echo "hup!"; exit "${E_SIGHUP}"; }
           trap::callback hup SIGHUP
           for((;;)) { sleep 0; }  # idle
        }
        child &
        cpid="${!}"

        sleep .2

        echo "hupping"
        kill -HUP "${cpid}"

        wait "${cpid}" 2> /dev/null
        '
    assert_output -p 'hupping'
    assert_output -p 'hup!'
}

@test "chain-registers callbacks" {
    run -0 bash -c \
        '
        source bashkit.bash
        trap::callback "echo \"one more thing\"" EXIT
        trap::callback "echo \"goodbye, world!\"" EXIT
        '
    assert_output -p 'goodbye, world!'
    assert_output -p 'one more thing'

    run -0 bash -c \
        '
        source bashkit.bash
        trap::callback "echo goodbye, world!" EXIT
        '
    assert_output -p 'goodbye, world!'
    refute_output -p 'one more thing'
}

@test "prevents custom callback on DEBUG when errcode is enabled" {
    is_bashand && skip 'need bash';

    run -2 bash -c \
        "source bashkit.bash; trap::callback 'echo debug trapped!' DEBUG;"
    assert_log 'fatal' 'trap' 'trap on debug is reserved to bashkit errcode'
    assert_log 'fatal' 'trap::callback' 'cannot add callback to trap DEBUG'
}

@test "allows custom callback on DEBUG when errcode is disabled" {
    run -0 bash -c \
        "source bashkit.bash; errcode::trap disable; trap::callback 'echo debug trapped!' DEBUG;"
    assert_log 'warn' 'errcode::trap' '!!! disabling errcode trap is not advised !!!'
    assert_output -p 'debug trapped!'
    refute_log 'fatal' 'trap' 'trap on debug is reserved to bashkit errcode'
    refute_log 'fatal' 'trap::callback' 'cannot add callback to trap DEBUG'
}

@test "succeeds on non catchable signal but doesn't run" {
    run -137 timeout 8s bash -c '
    source bashkit.bash
    child() {
        kill() { echo "kill!"; exit "${E_SIGKILL}"; }
        trap::callback kill SIGKILL
        for((;;)) { sleep 0; }  # idle
    }
    child &
    cpid="${!}"

    sleep .2

    echo "killing"
    kill -KILL "${cpid}"

    wait "${cpid}" 2> /dev/null
    '
    assert_output 'killing'
}

@test "fails on invalid signal specification" {
    run -1 timeout 8s bash -c '
    source bashkit.bash
    nop() { return $?; }
    trap::callback nop SIGNOP  # incorrect
    '
    assert_log 'fatal' 'trap::callback' 'cannot add callback to trap SIGNOP'
}

@test "does not know if trap specification is correct" {
    is_bashand && skip 'need bash';

    run -127 timeout 8s bash -c '
    source bashkit.bash
    kludge  # incorrect
    trap::callback kludge EXIT
    '
    assert_output -e 'bash: line [1-9]?: kludge: command not found'
}

@test "nop when missing args" {
    run -0 timeout 8s bash -c '
    source bashkit.bash
    trap::callback
    '
    assert_output ''
}
