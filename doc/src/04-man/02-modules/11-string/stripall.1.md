---
title: STRING::STRIPALL
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

string::stripall - remove pattern from string

# SYNOPSIS

string::stripall *str* *pat*

# DESCRIPTION

With *str* and *pat* two strings, `string::stripall` removes
all occurences of *pat* in *str*.

# EXAMPLE

    $ string::strip 'The Quick Brown Fox' '[aeiou]'
    Th Quck Brwn Fx

# SEE ALSO

`string::strip(1)`, `string::lstrip(1)`, `string::rstrip(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
