#!/usr/bin/env bash
# sete.bash --
# bashkit example
# set -e is useless in bashkit
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck source=/dev/null  # bashkit is in path

# plain bash unintuitive but posix behaviour
( set -e; false; echo passed; ); echo $?         # 1
# 1) false fails with 1,
# 2) `echo passed` is discarded by set -e
# 3) $? is subshell exit code 1

( set -e; false; echo passed; ) || echo failed   # passed
# 1) false fails with 1,
# 2) `echo passed` is NOT discarded by set -e because the subshell
#    is not last in the `||` construct, it runs and succeeds,
# 3) `echo failed` doesn't run because previous subshell success

# bashkit intuitive behaviour
source ../bashkit.bash

# set [-/+]e is not needed anymore, every failure is fatal unless handled

( false || echo passed ) || resume echo failed   # failed
# 1) false fails with 1,
# 2) `|| echo passed` is discarded by errcode,
# 3) `|| resume echo failed` is a valid errcode handler for the failed subshell

( false || resume echo passed ) || echo failed   # passed
# 1) false fails with 1,
# 2) `|| resume echo passed` is a valid errcode handler for false,
# 3) `|| echo failed` doesn't run because of `echo passed` (subshell) success

# these prove set -e has no effect here
( set -e; false || echo passed ) || resume echo failed  # failed as before
( set -e; false || resume echo passed ) || echo failed  # passed as before

# the following lines print nothing and exit code is 1
( set -e; false; echo passed; ); echo $?         # errcode handler stops short (exit 1) at false
( set -e; false; echo passed; ) || echo failed   # doesn't run past false
