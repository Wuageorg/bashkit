---
title: ARRAY::POPI
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---
# NAME

array::popi - remove the ith element from an array

# SYNOPSIS

array::popi *A* *i* [*x*]

# DESCRIPTION

With *A* an array variable *i* an index and *x* a variable, `array::popi`
sets *x* to the ith element from *A* before removing it. If *i* is negative,
the element is removed starting from the end of *A*. If *x* is not specified,
it defaults to the special variable `$__`.

`array::popi` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -a A=( 1 2 3 4 )
    $ array::popi A 2 x
    $ echo "${A[@]}"
    1 2 4
    $ echo "${x}"
    3

# SEE ALSO
`array::pop(1)`, `array::shift(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
