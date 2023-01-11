---
title: ARRAY::SHUFFLE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::shuffle - randomly reorder elements of an array

# SYNOPSIS

array::shuffle *A*

# DESCRIPTION

With *A* an array variable, `array::shuffle` performs in place a modern
fisher-yates shuffling.

`array::shuffle` returns 0 upon success, >0 otherwise.

# EXAMPLE
    $ declare -a A=( {1..8} )
    $ array::shuffle A
    $ echo "${A[@]}"
    7 6 2 1 3 4 5 8

# SEE ALSO
https://en.wikipedia.org/wiki/Fisher–Yates_shuffle#Modern_method

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
