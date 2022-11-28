% ARRAY::INTER(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

array::inter - intersect two arrays

# SYNOPSIS

array::inter *A* *B*

# DESCRIPTION

With *A* et *B* array variables, `array::inter` intersects *A* and *B*
and set the resulting array in *A*.

`array::inter` returns 0 unless wrong arguments or error >0.

# EXAMPLE

    $ declare -a A=( hello world 1 2 3 4 )
    $ declare -a B=( 3 4 5 6 goodbye world )
    $ array::inter A B
    $ echo "${A[@]}"
    3 4 world

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
