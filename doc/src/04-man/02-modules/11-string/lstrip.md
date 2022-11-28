% STRING::LSTRIP(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

string::lstrip - remove pattern from start of string

# SYNOPSIS

string::lstrip *str* *pat*

# DESCRIPTION

With *str* and *pat* two strings, `string::lstrip` removes
*pat* occuring at *str* start (or left side).

# EXAMPLES

    $ string::lstrip 'The Quick Brown Fox' 'The '
    Quick Brown Fox

# SEE ALSO

`string::rstrip(1)`, `string::strip(1)`, `string::stripall(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
