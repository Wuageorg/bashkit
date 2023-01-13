---
title: SHOPT::POP
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

shopt::pop - restores previous shopt context

# SYNOPSIS

shopt::pop

# DESCRIPTION

`shopt::pop` restores a builtin `shopt` context previously created
by calling `shopt::push(1)`.

`shopt::pop` always succeeds and returns 0.

# EXAMPLE

    $ shopt::push
    $ shopt -s extdebug
    $ do_something_with_extdebug_on
    $ shopt::pop

# SEE ALSO

builtin `shopt`, `shopt::push(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
