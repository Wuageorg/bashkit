#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

setup() {
    BASHKIT=${BATS_TEST_DIRNAME%test*}
    load "${BASHKIT}/test/helper/common-setup"
    _common_setup
}


@test "displays warning when executed" {
    run -1 bashkit.bash
    assert_output -p 'is to be sourced not executed!'
}

@test "loads specified modules and unset \$__ when sourced" {
    run -0 bash -c '
    source bashkit.bash string
    (( ${#BASHKIT[@]} > 0 ))
    [[ ! -v __ ]]
    string::trim " bashkit "
    '
    assert_output 'bashkit'  # trimmed!
}

@test "provides useful paths" {
    run -0 bash -c '
    source bashkit.bash
    bkdir=${BASHKIT[basedir]}
    ls "${bkdir}"
    scdir=${SCRIPT[basedir]}
    ls "${scdir}"
    '
    assert_output -p 'test'
}

@test "fix source argument passing" {
    printf '%s\n'                           \
        "#!/bin/env bash"                   \
        "source bashkit.bash"               \
        "echo \"\${@}\""                    \
    > "${BATS_TEST_TMPDIR}/script1.bash"

    run -0 bash "${BATS_TEST_TMPDIR}/script1.bash" "unknownmodule"
    assert_output 'unknownmodule'

    printf '%s\n'                           \
        "#!/bin/env bash"                   \
        "source bashkit.bash string.bash"   \
        "string::trim \"\${@}\""            \
    > "${BATS_TEST_TMPDIR}/script2.bash"

    run -0 bash "${BATS_TEST_TMPDIR}/script2.bash" "  xxx  "
    assert_output 'xxx'

    printf '%s\n'                           \
        "#!/bin/env bash"                   \
        "source bashkit.bash \"\${@}\""     \
        "string::trim \"\${@}\""            \
    > "${BATS_TEST_TMPDIR}/script3.bash"

    run -0 bash "${BATS_TEST_TMPDIR}/script3.bash" "string"
    assert_output 'string'
}
