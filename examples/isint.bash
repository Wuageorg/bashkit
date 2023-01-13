#!/usr/bin/env bash
# isint.bash --
# bashkit example
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck source=/dev/null  # bashkit is in path


source ../bashkit.bash

isint() {
    local n
    # shellcheck disable=SC2034  # n is fine
    printf -v n '%d' "${1:-}" &> /dev/null \
    || raise "not an int"
}

isint "abc" \
|| raise \
|| error
