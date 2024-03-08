#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

is_binpatch_compatible() {
    if (("${BASH_VERSINFO[0]}" < 5 )) \
    && { (("${BASH_VERSINFO[0]}" < 4 )) && (("${BASH_VERSINFO[1]}" < 1 )); }; then
        return 1
    fi
    if (("${BASH_VERSINFO[0]}" > 4 )) && (("${BASH_VERSINFO[1]}" > 2 )); then
        return 1
    fi
    return 0
}

@test "bashbinpatch do nothing if already bashand" {
    is_bashand || skip 'need bashand';

    run -0 bash -c '
    source bashkit.bash bashbinpatch
    bashbinpatch::handler
    '
    assert_output ''
}

@test "binpatch doesn't work with bash -c" {
    is_bashand && skip 'need bash';
    is_binpatch_compatible || skip 'need compatible bash';

    # shellcheck disable=SC2031,SC2030 # BASHBINPATCH_DIR is set for test
    export BASHBINPATCH_DIR="${BATS_TEST_TMPDIR}"

    run -1 bash -c '
    source bashkit.bash bashbinpatch
    warn() { :; } # remove warning
    bashbinpatch::handler enable || error
    '
    assert_log 'error' 'bashbinpatch__patch' 'bash -c, no dynamic bashand'
}

@test "binpatch fails on unimplemented hosttype" {
    is_bashand && skip 'need bash';
    is_binpatch_compatible || skip 'need compatible bash';

    # shellcheck disable=SC2031,SC2030 # BASHBINPATCH_DIR is set for test
    export BASHBINPATCH_DIR="${BATS_TEST_TMPDIR}"

    printf '%s\n'                           \
        "#!/bin/env bash"                   \
        "HOSTTYPE='unimplemented'"          \
        "source bashkit.bash bashbinpatch"  \
        "bashbinpatch::handler enable || error" \
    > "${BATS_TEST_TMPDIR}/script.bash"

    run -1 bash "${BATS_TEST_TMPDIR}/script.bash"

    assert_log 'error' 'bashbinpatch__patch' 'unimplemented unimplemented!'
}

@test "binpatch call the script again, bashand keeps arguments" {
    is_bashand && skip 'need bash';
    is_binpatch_compatible || skip 'need compatible bash';

    # shellcheck disable=SC2031,SC2030 # BASHBINPATCH_DIR is set for test
    export BASHBINPATCH_DIR="${BATS_TEST_TMPDIR}"

    printf '%s\n'                                         \
        "#!/bin/env bash"                                 \
        "source bashkit.bash check bashbinpatch"          \
        "bashbinpatch::handler enable \"\$@\" || fatal"   \
        "f() {"                                           \
        "   false"                                        \
        "   true"                                         \
        "}"                                               \
        "f || echo \"\$@\""                               \
    > "${BATS_TEST_TMPDIR}/script.bash"

    run -0 timeout 2s bash "${BATS_TEST_TMPDIR}/script.bash" bashand is cool
    assert_log 'warn' 'bashbinpatch::handler' '... binpatching is dirty, and might not work with all bash versions'
    assert_output -p 'bashand is cool'
}
