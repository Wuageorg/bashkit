#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "alias restores if-then-else control flow" {
    run -0 bash -c '
    source bashkit.bash
    type -a else

    if true; then
      printf "passed #1\n"
    else
      printf "unreachable\n"
    fi

    if false; then
      printf "unreachable\n"
    else
      printf "passed #2\n"
    fi
    '
    assert_output -e 'else is aliased to .else true;.'
    assert_output -p 'else is a shell keyword'
    assert_output -p 'passed #1'
    assert_output -p 'passed #2'
    refute_output 'unreachable'
}
