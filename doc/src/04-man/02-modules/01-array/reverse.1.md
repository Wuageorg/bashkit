---
title: ARRAY::REVERSE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::reverse - reverse an array in place

# SYNOPSIS

array::reverse *A*

# DESCRIPTION

With *A* an array variable, `array::reverse` reverses *A* in place.

`array::reverse` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -a A=( {1..11} )
    $ array::reverse A
    $ echo "${A[@]}"
    11 10 9 8 7 6 5 4 3 2 1

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
