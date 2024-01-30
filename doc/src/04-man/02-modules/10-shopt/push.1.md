---
title: SHOPT::PUSH
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

shopt::push - create a new shopt context

# SYNOPSIS

shopt::push

# DESCRIPTION

`shopt::push` creates a new `shopt` context that can be modified
and discarded later by a call to `shopt::pop(1)`.

`shopt::push` always succeeds and returns 0.

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
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
