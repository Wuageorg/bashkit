# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source string.bash


@test "strips all instances of pattern from string" {
    assert_equal "$( string::stripall 'The Quick Brown Fox' '[aeiou]'     )" 'Th Qck Brwn Fx'
    assert_equal "$( string::stripall 'The Quick Brown Fox' '[[:space:]]' )" 'TheQuickBrownFox'
    assert_equal "$( string::stripall 'The Quick Brown Fox' 'Quick '      )" 'The Brown Fox'
}
