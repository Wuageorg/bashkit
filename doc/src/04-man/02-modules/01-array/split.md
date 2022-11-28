% ARRAY::SPLIT(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

array::split - build an array from a split string

# SYNOPSIS

array::split *A* *str* *sep*

# DESCRIPTION

With *A* an array variable, *str* and *sep* two strings, `array::split` divides *str*
into an ordered list of substrings by searching for *sep*, puts these substrings in
*A*.

`array::split` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -a A
    $ array::split A 'apples,oranges,pears,grapes' ','
    $ echo "${A[@]}"
    apples oranges pears grapes

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
