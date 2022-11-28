#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

# shellcheck source=/dev/null  # extras in path
source extras.bash


@test "encodes url" {
    run -0 urlencode "https://github.com/dylanaraps/pure-bash-bible"
    assert_output -p 'https%3A%2F%2Fgithub.com%2Fdylanaraps%2Fpure-bash-bible'
}

@test "decodes url" {
    run -0 urldecode "https%3A%2F%2Fgithub.com%2Fdylanaraps%2Fpure-bash-bible"
    assert_output -p 'https://github.com/dylanaraps/pure-bash-bible'
}
