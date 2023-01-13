#!/usr/bin/env bash
# mycheck.bash --
# bashkit example
# use errcode to create check_cmd
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck source=/dev/null  # bashkit is in path

source ../bashkit.bash

# set -x

check_cmd(){
    local cmd=$1
    command -v "${cmd}" &> /dev/null \
    || raise "not found: ${cmd}"
}

main() {
    check_cmd isint \
    || {
           catch
           isint() {
              printf '%d' "$1" > /dev/null 2>&1 \
              || raise 'invalid number'
           }
    }

    isint 1 \
    && echo yep \
    || echo nope

    # shellcheck disable=SC2015  # this construct is ok
    isint not_an_int \
    && echo yep \
    || resume echo nope
}

main
