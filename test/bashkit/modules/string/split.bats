
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source string.bash


@test "splits string on delimiter" {
    run -0 string::split 'apples,oranges,pears,grapes' ','
    assert_output -e 'apples[[:space:]]oranges[[:space:]]pears[[:space:]]grapes'

    run -0 string::split '1, 2, 3, 4, 5' ', '
    assert_output -e '1[[:space:]]2[[:space:]]3[[:space:]]4[[:space:]]5'
}

@test "splits string on multi-chars delimiter" {
    run -0 string::split 'apples,oranges,pears,grapes' ','
    assert_output -e 'apples[[:space:]]oranges[[:space:]]pears[[:space:]]grapes'

    run -0 string::split 'hello---world---!' '---'
    assert_output -e 'hello[[:space:]]world[[:space:]]!'
}
