---
title: STRING::RSTRIP
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

string::rstrip - remove pattern from end of string

# SYNOPSIS

string::rstrip *str* *pat*

# DESCRIPTION

With *str* and *pat* two strings, `string::rstrip` removes
*pat* occuring at *str* end (or right side).

# EXAMPLE

    $ string::rstrip 'The Quick Brown Fox' ' Fox'
    The Quick Brown

# SEE ALSO

`string::lstrip(1)`, `string::strip(1)`, `string::stripall(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
