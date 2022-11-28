#!/usr/bin/env bash
# hello.bash --
# bashkit example
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck source=/dev/null  # bashkit is in path

source ../bashkit.bash
info 'hello world!'
