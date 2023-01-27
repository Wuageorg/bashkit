#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock
# shellcheck source=/dev/null # File is in path
source patch.bash && patch::init


@test "applies all in directory" {
    mkdir -p "${BATS_TEST_TMPDIR}/patches"
    # create files to patch
    cat > "${BATS_TEST_TMPDIR}/patches/ptch1.patch" <<-EOF
--- /dev/null 2022-09-10 23:25:01.256633871 +0200
+++ c         2022-09-10 23:25:21.348780325 +0200
@@ -0,0 +1 @@
+aa
EOF
    cat > "${BATS_TEST_TMPDIR}/patches/ptch2.patch" <<-EOF
--- /dev/null 2022-09-10 23:25:01.256633871 +0200
+++ d         2022-09-10 23:25:21.348780325 +0200
@@ -0,0 +1 @@
+bb
EOF

    patch::batch "${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/patches"
    assert_equal "${__}" "applied ${BATS_TEST_TMPDIR}/patches patches to ${BATS_TEST_TMPDIR}"
    [[ -f "${BATS_TEST_TMPDIR}/c" ]]  # created file
    [[ -f "${BATS_TEST_TMPDIR}/d" ]]  # created file
}

@test "fails on missing directory" {
    E_ASSERT_FAILED=10
    patch::batch "${BATS_TEST_TMPDIR}" 'inexistent' \
    || _rc=${?}
    assert_equal "${_rc}" "${E_ASSERT_FAILED}"
    assert_equal "${__}" 'dir not found: inexistent'
}

@test "fatals on incorrect invocation" {
    f() {
        patch::batch
    }

    run -9 f
    assert_output 'fatal: incorrect invocation'
}
