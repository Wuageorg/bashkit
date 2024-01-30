---
title: ARRAY::PUSH
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::push - add one or more elements to the end of an array

# SYNOPSIS

array::push *A* [*x* ...]

# DESCRIPTION

With *A* an array variable *x* a value, `array::push` adds *x* at the end
of *A*.

`array::push` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -a A=( {1..11} )
    $ array::push A 12
    $ echo "${A[-1]}"
    12

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
