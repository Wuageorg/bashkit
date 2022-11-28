% STRING::REGEX(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

string::regex - match string against regular expression

# SYNOPSIS

string::regex *str* *rex*

# DESCRIPTION

With *str* and *rex* two strings, `string::regex` matches *str*
again regular expression *rex* and displays the matching part of
*str*.

`string::regex` returns 0 upon match, >0 otherwise.

# EXAMPLE

    $ string::regex '    hello' '^[[:space:]]*(.*)'
    hello

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
