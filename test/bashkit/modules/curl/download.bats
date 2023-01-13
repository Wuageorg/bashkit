#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "downloads if reachable url" {
    nc -z -w1 example.com 80 || skip "example.com is unreachable"

    run -0 timeout 6s bash -c '
    LOGLEVEL=7
    source bashkit.bash curl
    tmpfile=${BATS_TEST_TMPDIR}/example.com.html
    curl::download http://example.com "${tmpfile}"
    '
    assert_output -e 'curl::download:[0-9]+\| downloaded'
}

@test "fails gracefully if unreachable url" {
    run -1 timeout 6s bash -c '
    source bashkit.bash curl
    tmpfile=${BATS_TEST_TMPDIR}/example.com.html

    curl::download wont://work "${tmpfile}" \
    || error
    '
    assert_log 'error' 'curl::download' \
        'curl: \(1\) Protocol "wont" not supported or disabled in libcurl'
    refute_output -e 'curl::download:[0-9]+ \| downloaded'
}
