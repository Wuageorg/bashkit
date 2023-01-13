---
title: ARRAY::REDUCE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::reduce - perform a summary operation of an array

# SYNOPSIS

array::reduce *A* *fun* *acc*

# DESCRIPTION

With *A* an array variable, *fun* a bash function that aggregates `$1`
and `$2` and prints the result to `stdout` and *acc* a variable,
`array::reduce` sumarizes *A* into *acc* by repetitively aplying
`fun acc x` for *x* in *A*.

`array::reduce` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -a A=( {1..8} )
    $ add() { echo $(( $1 + $2 )); }
    $ acc=0
    $ array::reduce A add acc
    $ echo "${acc}"
    36

# SEE ALSO
`array::map(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
