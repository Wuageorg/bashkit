#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock
# shellcheck source=/dev/null # File is in path
source patch.bash && patch::init


@test "patch a file" {
    # create file to patch
    cat > "${BATS_TEST_TMPDIR}/ptch.patch" <<-EOF
--- /dev/null 2022-09-10 23:25:01.256633871 +0200
+++ c         2022-09-10 23:25:21.348780325 +0200
@@ -0,0 +1 @@
+aa
EOF

    patch::apply "${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/ptch.patch"
    assert_equal "${__}" "applied ${BATS_TEST_TMPDIR}/ptch.patch to ${BATS_TEST_TMPDIR}"
    [[ -f "${BATS_TEST_TMPDIR}/c" ]] # File created
}

@test 'fail on missing file' {
    # create file to patch

    E_ASSERT_FAILED=10
    patch::apply "${BATS_TEST_TMPDIR}" 'inexistent' \
    || _rc=$?
    assert_equal "${_rc}" "${E_ASSERT_FAILED}"
    assert_equal "${__}" 'file not found: inexistent'
}

@test 'fatal on incorrect invocation' {
    run -9 patch::apply
    assert_output 'fatal: incorrect invocation'
}
