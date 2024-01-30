---
title: ARRAY::ROTATE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::rotate - shift elements of an array to the specified positions

# SYNOPSIS

array::rotate *A* *i*

# DESCRIPTION

With *A* an array variable and *i* an integer, `array::rotate` shifts
elements of *A* to the specified positions. If *i* is positive, cycling
is done from right to left, if *i* is negative, cycling occurs from
left to right.

`array::rotate` returns 0 upon success, >0 otherwise.

# EXAMPLES

    $ declare -a A=( {1..8} )
    $ array::rotate A -10
    $ echo "${A[@]}"
    3 4 5 6 7 8 1 2

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
