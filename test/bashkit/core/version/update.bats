#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source version.bash


@test 'succeeds with correct values' {
    # shellcheck disable=SC2154,SC2034  # basedir is fine
    BASHKIT[basedir]="${BATS_TEST_TMPDIR}"

    # Mock everything
    # shellcheck disable=SC2034  # BASHKIT_VERSION is used
    declare -A BASHKIT_VERSION=( [compat]=24 [date]=3112 [commit]=1829 [branch]=notmain )
    bashkit::load() { :; }
    check::cmd() { :; }
    sed() { echo "$2"; }
    git() {
        git__rev-list() { echo 10; }
        git__branch() { echo main; }
        git__"$1" "$@"
    }
    find() { true; }
    md5sum() {
        cat > /dev/null # remove self input
        printf '%s  %s\n' '7f49c14bbba205195ce1b743cb3b2f64' 'mock1'
        printf '%s  %s\n' '46f2b3bc347b1ec591502abbb41c94f7' 'mock2'
        printf '%s  %s\n' '91502abbb41c94f746f2b3bc347b1ec5' 'file with space'
    }
    local now
    printf -v now '%(%y%m)T' -1 # 2 digits current year and month

    run -0 version::update
    assert_output "s|^#@BASHKIT_VERSION=.*\$|#@BASHKIT_VERSION=( [compat]='24' [date]='${now}' [commit]='11' [branch]='main' )|;s|^#@BASHKIT_HASHES=.*\$|#@BASHKIT_HASHES=( [mock1]='7f49c14bbba205195ce1b743cb3b2f64' [mock2]='46f2b3bc347b1ec591502abbb41c94f7' [file with space]='91502abbb41c94f746f2b3bc347b1ec5' )|"
}
