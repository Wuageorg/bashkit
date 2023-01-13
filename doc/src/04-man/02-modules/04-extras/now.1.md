---
title: NOW
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

now - get the number of milliseconds elapsed since EPOCH

# SYNOPSIS

now [*dest*]

# DESCRIPTION

`now` is part of bashkit module `extras`, it sets *dest* var to
the number of milliseconds elapsed since EPOCH. If *dest* is
omitted, `now` sets the special variable `$__`.

# EXAMPLE
      $ now start
      $ sleep 1
      $ now end
      $ echo $(( end - start ))
      1008

# AUTHORS
Written by \\Nuage
# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
