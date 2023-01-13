---
title: ARRAY::PICK
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::pick - pick a random array element

# SYNOPSIS

array::pick *A* [*x*]

# DESCRIPTION

With *A* an array variable and *x* a variable, `array::pick` sets *x*
to a random element of *A*. If *x* is not specified, it defaults to
the special variable `$__`.

`array::pick` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -a A=( 1 2 3 4 )
    $ array::pick A x
    $ echo "${x}"
    3

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
