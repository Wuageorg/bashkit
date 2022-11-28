#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "bubbles error" {
    run -1 bash -c '
    source bashkit.bash
    f() {
        echo "passed"
        false  # error! (1)
        echo "unreachable"
        return 2
    }
    f
    '
    assert_output 'passed'
    refute_output -p 'unreachable'
}

@test "transfers control to exit" {
    run -3 bash -c '
    source bashkit.bash
    f() {
        echo "passed"
        false  # error! (1)

        echo "unreachable"
        return 2
    }
    f || exit 3
    '
    assert_output 'passed'
    refute_output -p 'unreachable'
}

@test "resumes exec using true" {
    run -0 bash -c '
    source bashkit.bash
    f() {
        echo "passed"
        false  # error! (1)
        echo "unreachable"
        return 1
    }
    f || true
    '
    assert_output 'passed'
    refute_output -p 'unreachable'
}

@test "substitutes error code using return" {
    run -2 bash -c '
    source bashkit.bash
    f() {
        echo "passed"
        false  # error! (1)
        echo "unreachable"
        return 1
    }
    g() { f || return 2; }
    g
    '
    assert_output -p 'passed'
    refute_output -p 'unreachable'
}

@test "catches error" {
    run -0 bash -c '
    source bashkit.bash
    f() {
        echo "passed"
        false  # error! (1)
        echo "unreachable"
        return 2
    }
    g() {
        f \
        || resume echo "catched"
    }
    g
    '
    assert_output -e 'passed[[:space:]]+catched'
    refute_output -p 'unreachable'
}

@test "resume clear \${__}" {
    run -0 bash -c '
    source bashkit.bash
    f() {
        __="result"
        false
    }
    f || resume
    echo "${__:-${__[@]:-}}"
    '
    assert_output ''
}

@test "doesn't catch from early subshell eval" {
    # sadly this doesn't work as bash evaluate subshell first
    run -0 bash -c \
    '
    source bashkit.bash

    f() {
        echo "passed"
        false  # error! (1)

        echo "unreachable"
        return 2
    }
    g() {
        f \
        || resume echo A $(printf "%s" catched)
    }
    g
    '
    assert_output -e 'passed[[:space:]]+A'
    refute_output -p 'unreachable'
}

@test "can be tricked to catch from early subshell eval" {
    # catchpow3 use true trick
    run -0 bash -c '
    source bashkit.bash

    f() {
        echo "passed"
        false  # error! (1)
        echo "unreachable"
        return 2
    }
    g() {
        f \
        || resume echo A $(true; printf "%s" catched);
    }
    g
    '
    assert_output -e 'passed[[:space:]]+A catched'
    refute_output -p 'unreachable'
}

@test "accepts if-then-else construct" {
    run -2 bash -c '
    source bashkit.bash
    f() {
        echo "passed"
        false  # error! (1)
        echo "unreachable"
        return 2
    }
    if ! f; then exit 2; else exit 3; fi
    '
    assert_output 'passed'
    refute_output -p 'unreachable'

    # this should print "else!" and return 0
    run -0 bash -c '
    source bashkit.bash
    f() {
        echo "passed"
        return 1
        echo "unreachable"
        return 2
    }
    if f; then exit 3; else echo "else!"; fi
    '
    assert_output -e 'passed[[:space:]]+else\!'
    refute_output -p 'unreachable'
}

@test "honors continue control flow" {
    run -0 bash -c '
    source bashkit.bash
    for i in 0 1 2 3 4 5; do
        (( i != 3 )) || continue
        echo -n "${i} "
    done
    '
    assert_output -p '0 1 2 4 5'
    refute_output -p '3'
}

@test "honors break control flow" {
    run -0 bash -c '
    source bashkit.bash
    for (( i=0; i < 6; i++ )); do
        (( i != 3 )) || break
        echo -n "${i} "
    done
    '
    assert_output -p '0 1 2'
    refute_output -p '3'
    refute_output -p '4'
    refute_output -p '5'
}

@test "accepts log fatal|panic|alert|crit|error|debug" {
    run -7 bash -c '
    source bashkit.bash
    logging::setlevel 7

    ( (exit 2) || fatal $? ) \
    || true

    ( (exit 3) || panic $? ) \
    || true

    ( (exit 4) || alert $? ) \
    || true

    ( (exit 5) || crit $? ) \
    || true

    ( (exit 6) || error $? ) \
    || true

    ( (exit 7) || debug $? )
    '
    assert_log 'fatal' '' '2'
    assert_log 'panic' '' '3'
    assert_log 'alert' '' '4'
    assert_log 'crit'  '' '5'
    assert_log 'error' '' '6'
    assert_log 'debug' '' '7'
}

@test "refuses log warn|info|note" {
    is_bashand && skip 'need bash';

    run -0 bash -c '
    source bashkit.bash
    logging::setlevel 7
    ( (exit 2) || warn $? ) \
    || resume printf "%s " $?

    ( (exit 3) || info $? ) \
    || resume printf "%s " $?

    ( (exit 4) || note $? ) \
    || resume printf "%s" $?
    '
    assert_output '2 3 4'
}
