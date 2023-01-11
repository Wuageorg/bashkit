---
title: ARRAY::UNIQ
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::uniq - deduplicate elements of an array

# SYNOPSIS

array::uniq *A*

# DESCRIPTION

With *A* an array variable, `array:uniq` deduplicates elements in place.

`array::uniq` returns 0 upon success, >0 otherwise.

# EXAMPLES

    $ declare -a A=( {1..8} )
    $ A+=( "${A[@]}" )  # duplicate array items
    $ echo "${A[@]}"
    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8
    $ array::uniq A
    $ echo "${A[@]}"
    1 2 3 4 5 6 7 8

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
