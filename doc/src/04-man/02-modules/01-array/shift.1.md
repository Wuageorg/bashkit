---
title: ARRAY::SHIFT
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::shift - remove the first element of an array

# SYNOPSIS

array::shift *A* [*x*]

# DESCRIPTION

With *A* an array variable and *x* a variable, `array::shift` removes the first
element of *A* and sets *x* to it. If *x* is not given, it defaults to special
variable `$__`.

`array::shift` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -a A=( {1..8} )
    $ array::shift A x
    $ (( x == 1 )) && echo "${A[@]}"
    2 3 4 5 6 7 8

# SEE ALSO
`array::popi(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
