---
title: ISINT
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

isint - test for integers

# SYNOPSIS

isint [*x* ...]

# DESCRIPTION

`isint` is part of bashkit module `extras`,
given *x* a value, it tests if *x* is an integer.

`isint` returns 0 if all *x* are integers, >0 otherwise.

# EXAMPLE
      $ n=10
      $ isint "${n}" 1 2 3 4 || echo yes
      $ yes

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
