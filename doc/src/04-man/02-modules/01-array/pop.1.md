---
title: ARRAY::POP
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---
# NAME

array::pop - remove the last element from an array

# SYNOPSIS

array::pop *A* [*x*]

# DESCRIPTION

With *A* an array variable and *x* a variable, `array::pop` sets *x*
to the last element from *A* before removing it. If *x* is not specified,
it defaults to the special variable `$__`.

`array::pop` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -a A=( 1 2 3 4 )
    $ array::pop A x
    $ echo "${A[@]}"
    1 2 3
    $ echo "${x}"
    4

# SEE ALSO
`array::popi(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
