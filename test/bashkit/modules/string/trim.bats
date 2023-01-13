# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source string.bash


@test "trims leading and trailing white spaces from string" {
    assert_equal "$( string::trim '    Hello,  World    ' )" 'Hello,  World'
}
