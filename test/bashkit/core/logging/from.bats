#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock


source logging.bash

@test "keeps main function name" {

    main() {
        info x
    }

    run -0 main
    assert_log 'info' 'main' 'x'

    main() {
        raise x || resume note
    }

    run -0 main
    assert_log 'note' 'main' 'x'
}

@test "displays script name at top level" {

    printf '%s\n' \
        "#!/usr/bin/env bash" \
        "source bashkit.bash" \
        "raise 'help' || resume warn needhelp" \
    > "${BATS_TEST_TMPDIR}/script.sh"

    run -0 bash "${BATS_TEST_TMPDIR}/script.sh"
    assert_log 'warn' "${BATS_TEST_TMPDIR}/script.sh" 'needhelp'

    run -0 bash -c "source bashkit.bash; raise 'help' || resume warn needhelp"
    assert_log 'warn' '' 'needhelp'
}
