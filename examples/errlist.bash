#!/usr/bin/env bash
# errlist.bash --
# bashkit example
# list defined errors
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck source=/dev/null  # bashkit is in path

source ../bashkit.bash curl

error::list | column -t -s "="
