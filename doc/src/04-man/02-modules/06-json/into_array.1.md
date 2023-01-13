---
title: JSON::INTO_ARRAY
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

json::into_array - load a json array into a bash array

# SYNOPSIS

json::into_array *A* *jarr*

# DESCRIPTION

With *A* an array variable and *jarr* a string representing a json array,
`json::into_array` loads *jarr* content into *A*.

`json::into_array` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ json='["a", "b", 3, 7]'
    $ declare -a A
    $ json::into_array A <<< "${json}"
    $ echo "${A[@]}"
    a b 3 7

# SEE ALSO

`json::into_dict(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
