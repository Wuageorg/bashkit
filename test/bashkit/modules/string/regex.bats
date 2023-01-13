# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source string.bash


@test "uses regex on a string" {
    assert_equal "$( string::regex '    hello' '^[[:space:]]*(.*)' )"                     'hello'
    assert_equal "$( string::regex '#FFFFFF'   '^(#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3}))$' )" '#FFFFFF'
}

@test "fails if no match" {
    empty=$( string::regex 'red' '^(#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3}))$' ) \
    || _rc=$?
    assert_equal "${_rc}" 1
    assert_equal "${empty}" ''
}
