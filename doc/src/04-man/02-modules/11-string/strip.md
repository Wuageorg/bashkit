% STRING::STRIP(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

string::strip - remove first occuring pattern from string

# SYNOPSIS

string::strip *str* *pat*

# DESCRIPTION

With *str* and *pat* two strings, `string::strip` removes
the first occurence of *pat* in *str*.

# EXAMPLE

    $ string::strip 'The Quick Brown Fox' '[aeiou]'
    Th Quick Brown Fox

# SEE ALSO

`string::stripall(1)`, `string::lstrip(1)`, `string::rstrip(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
