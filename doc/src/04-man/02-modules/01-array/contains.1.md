---
title: ARRAY::CONTAINS
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::contains - test if an array contains a given value

# SYNOPSIS

array::contains *A* *x* [*idx*]

# DESCRIPTION

With *A* an array variable, *x* a value and *idx* a variable, `array::contains`
test if *x* exists in *A* and set *idx* to *x* index. If *idx* is not given,
the index is set in special variable `$__`.

`array::contains` returns 0 if *x* in *A*, >0 otherwise or if an error occurs.

# EXAMPLE

    $ declare -a ARRAY=( 1 2 3 4 )
    $ array::contains ARRAY 2 idx
    $ echo $?
    0
    $ echo "${ARRAY[idx]}"
    2

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
