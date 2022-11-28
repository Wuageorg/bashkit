#!/usr/bin/env bash
# oshcomp.bash --
# bashkit example
# compare bashkit to oilsh
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck source=/dev/null  # bashkit is in path

source ../bashkit.bash

__=$(date X 2>&1) \
|| error \
|| catch

# shellcheck disable=SC2015  # first command fails on purpose
__=$(date X 2>&1) \
&& ls \
|| error \
|| catch

# shellcheck disable=SC2012  # same example as osh
__=$( { ls /__bad__ | wc; } 2>&1 )\
|| error \
|| catch

yes | head > /dev/null \
|| catch

myfunc() (
  exit 1         # fails with status 1
  echo 'unreachable'
)

myfunc || catch # script aborts before echo

if myfunc; then  # behaves differently in a condition.
  echo OK
fi

# this one evades shellcheck, bash and shellcheck
diff <(exit 1) <(exit 2)
echo $?
