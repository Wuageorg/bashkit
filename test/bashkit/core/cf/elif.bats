#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "alias restores if-then-elif-else control flow" {
   run -0 bash -c '
   source bashkit.bash
   type -a elif

   if false; then
      printf "unreachable\n"
   elif true; then
      printf "passed #1\n"
   else
      printf "unreachable\n"
   fi

   if false; then
      printf "unreachable\n"
   elif false; then
      printf "unreachable\n"
   else
      printf "passed #2\n"
   fi
   '
   assert_output -e 'elif is aliased to .elif true &&.'
   assert_output -p 'elif is a shell keyword'
   assert_output -p 'passed #1'
   assert_output -p 'passed #2'
   refute_output 'unreachable'
}
