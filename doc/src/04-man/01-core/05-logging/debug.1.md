---
title: DEBUG
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

debug - display a debugging message

# SYNOPSIS

debug [*message* ...]

# DESCRIPTION

With *message* a string, `debug` takes an arbitrary number of *message*
arguments.
*message* can be set in special variable `$__`.

If `$LOGLEVEL` is set to 7 beforehand or at runtime each message is displayed
on its own.

When `$TRACE` or `$REPORT` are set, `$LOGLEVEL` defaults to 7

`debug` returns success unless a write or assignment error occurs.

# EXAMPLES

    $ debug
    2022-11-08 00:59:32+0100 [debug] bash:1|

    $ debug "debug message"
    2022-11-08 01:00:03+0100 [debug] bash:1| debug message

    $ __='preset message' && debug
    2022-11-08 01:00:57+0100 [debug] bash:1| preset message

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
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
