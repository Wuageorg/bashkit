% ARRAY::MAP(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

array::map - apply a function to an array elements

# SYNOPSIS

array::map *A* *fun*

# DESCRIPTION

With *A* an array variable and *fun* a bash function that transforms `$1`
and prints the result to `stdout`, `array::map` applies *fun* in place
to each elements of *A*.

`array::map` returns 0 upon success >0 otherwise.

# EXAMPLES

    $ declare -a A=( {a..e} )
    $ up(){ echo ${1^^}; }
    $ array::map A up
    $ echo "${A[@]}"
    A B C D E

# SEE ALSO
`array::reduce(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
