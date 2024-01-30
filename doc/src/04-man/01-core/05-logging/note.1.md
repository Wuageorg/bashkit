---
title: NOTE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

note - display a note message

# SYNOPSIS

note [*message* ...]

# DESCRIPTION

With *message* a string, `note` takes an arbitrary number of *message*
arguments.
*message* can be set in special variable `$__`.

If `$LOGLEVEL` is >= 5 beforehand or set at runtime each message
is displayed on its own.

`note` returns success unless a write or assignment error occurs.

# EXAMPLES

    $ note
    2022-11-08 00:59:32+0100 [note] bash:1|

    $ note "note message"
    2022-11-08 01:00:03+0100 [note] bash:1| note message

    $ __='preset message' && note
    2022-11-08 01:00:57+0100 [note] bash:1| preset message

# ENVIRONMENT

- $JSON controls the output format
- $LOGLEVEL controls the logging level
- $NO_COLOR controls the output colorization

# SEE ALSO

`logging::level(1)`, `logging::setlevel(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
