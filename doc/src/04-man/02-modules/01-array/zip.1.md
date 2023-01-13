---
title: ARRAY::ZIP
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

array::zip - merge two arrays in a dictionary

# SYNOPSIS

array::zip *D* *K* *V*

# DESCRIPTION

With *D* an dictionary (ie. associative array), *K* and *V* two arrays,
`array::zip` merges the arrays into a dict where keys are taken from *K*
ans associated to values taken in turn from *V*.

`array::zip` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ declare -A D
    $ declare -a K=( {a..e} )
    $ declare -a V=( {1..8} )
    $ array::zip D K V
    $ declare -p D
    D=([e]="5" [d]="4" [c]="3" [b]="2" [a]="1" )

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
