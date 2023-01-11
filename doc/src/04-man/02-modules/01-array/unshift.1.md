---
title: ARRAY::UNSHIFT
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::unshift - add one or more elements to the beginning of an array

# SYNOPSIS

array::unshift *A* [*x* ...]

# DESCRIPTION

With *A* an array variable and a list of values *x*, `array::unshift` adds
them to the beginning of *A*

`array::unshift` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -a A=( {4..8} )
    $ array::unshift A 1 2 3
    $ echo "${A[@]}"
    1 2 3 4 5 6 7 8

# AUTHORS
Written by \\Nuage
# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
