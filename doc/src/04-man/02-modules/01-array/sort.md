% ARRAY::SORT(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

array::sort - sort elements of an array in place

# SYNOPSIS

array::sort *A*

# DESCRIPTION

With *A* an array variable, `array::sort` in place sorts the array.

`array::sort` returns 0 upon success, >0 otherwise.

# EXAMPLES

    $ declare -a A=( 8 7 5 6 3 4 1 2 )
    $ array::sort A
    $ echo "${A[@]}"
    1 2 3 4 5 6 7 8

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
