#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "can resume on a subshell command" {
    run -0 bash -c '
    source bashkit.bash
    f() {
        (exit 2) \
        ||  raise $? "$( resume printf "|resuming %d during %s|" $? "${FUNCNAME[0]}" )"
    }
    f \
    || resume echo "after f rc: $? msg: ${__:-} __: ${__[@]:-}"
    '
    assert_output -e 'after f rc: 2 msg: |resuming 2 during f| __: |resuming 2 during f| environment f [0-9]+'
}

@test "sets \${__} with message and passes return code" {
    run -0 bash -c '
    source bashkit.bash
    f() {
        raise 7 "reason#7"
    }
    f || resume echo "$? ${__} ${__[@]}"
    '
    assert_output -e '7 reason#7 reason#7 environment f [0-9]+'
}

@test "prevents user to raise 0 (preserves predictable control flow)" {
    run -0 bash -c \
    '
    source bashkit.bash
    f() {
        raise 0 "reason 0"
    }
    f || resume echo "$? ${__} ${__[@]}"
    '
    assert_output -e '1 reason 0 reason 0 environment f [0-9]'
}

@test "raises 1 when called alone" {
    run -0 bash -c \
    '
    source bashkit.bash
    f() {
        raise
    }
    f || resume echo "$? ${__:-unbound} ${__[@]}"
    '
    assert_output -p '1 unbound'
}

@test "is polymorphic" {
    run -6 bash -c '
    source bashkit.bash
                                 raise               || error || catch  # noarg       | raise   1  ""
                                 raise "failed $?"   || error || catch  # reason      | raise   1  "failed 0"
    (exit 2)                  || raise "failed $?"   || error || catch  # reason      | reraise 2  "failed 2"
    (exit 2)                  || raise 3 "failed $?" || error || catch  # code reason | raise   3  "failed 2"
    (exit 2)                  || raise 4             || error || catch  # code        | raise   4  ""
    (exit 2)                  || raise 5 "reason 5"  || error || catch  # code reason | raise   5  "reason 5"
    __="reason 2" && (exit 2) || raise 6             || error           # code        | raise   6  "reason 2"
    '
    assert_log 'error' '' '(.|failed (0|2)|reason (2|5))'
}
