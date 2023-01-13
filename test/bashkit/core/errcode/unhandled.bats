#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016 # Allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "logs crit \${__} when an error is pending" {
    run -7 bash -c '
    source bashkit.bash
    f() {
        raise 7 "unhandled"
    }
    f
    '
    assert_log 'crit' 'f' 'unhandled'
}

@test "ends gracefully when no pending error" {
    run -0 bash -c '
    source bashkit.bash
    f() {
        raise 7 "handled"
    }
    f || catch
    '
    assert_output ''
}

@test "logs pending error only once" {
    run -7 bash -c '
    source bashkit.bash
    f() {
        raise 7 "handled"
    }
    f || error
    '
    assert_log 'error' 'f' 'handled'
    refute_log 'crit' 'f' 'handled'
}

@test "logs pending error only once when logging level is CRIT/2" {
    run -7 bash -c '
    source bashkit.bash
    logging::setlevel 2 && __=()
    f() {
        raise 7 "handled"
    }
    f || error
    '
    assert_log 'crit' 'f' 'handled'
    refute_log 'error' 'f' 'handled'
}

@test "does not get in the way when panicking" {
    run -1 bash -c '
    source bashkit.bash
    f() {
        raise 7 "handled"
    }
    f || panic
    '
    assert_log 'panic' 'f' 'handled'
    refute_log 'crit' 'f' 'handled'
}

@test "sets \${__} on error if empty" {
    run -0 bash -c '
    source bashkit.bash
    f() {
        __=not_empty
        (exit 10)
        not false # we need to commands here
    }
    f || catch
    echo ${__}
    '
    assert_output 'not_empty'

    run -0 bash -c '
    source bashkit.bash
    f() {
        (exit 10)
        not false # we need a command so we use not
    }
    f || catch
    echo ${__}
    '
    assert_output 'uncaught error code 10'
}

@test "logs \${__} with DEBUG/7 when in subshell" {
    run -7 bash -c '
    source bashkit.bash
    set -o errtrace
    logging::setlevel debug && __=()
    f() {
        raise 7 "unhandled sub"
    }
    (f)
    '
    assert_log 'debug' 'f' 'unhandled sub'
}
