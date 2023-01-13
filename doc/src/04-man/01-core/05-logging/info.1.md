---
title: INFO
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

info - display an informational message

# SYNOPSIS

info [*message* ...]

# DESCRIPTION

With *message* a string, `info` takes an arbitrary number of *message*
arguments.
*message* can be set in special variable `$__`.

If `$LOGLEVEL` is >= 6 beforehand or set at runtime each message
is displayed on its own.

`info` returns success unless a write or assignment error occurs.

`info` shadows `info(1)` the bash info document reader. If you need to use
 this reader, invoke it with `command` `info`.

# EXAMPLES

    $ info
    2022-11-08 00:59:32+0100 [info] bash:1|

    $ info "info message"
    2022-11-08 01:00:03+0100 [info] bash:1| info message

    $ __='preset message' && info
    2022-11-08 01:00:57+0100 [info] bash:1| preset message

# ENVIRONMENT

- $JSON controls the output format
- $LOGLEVEL controls the logging level
- $NO_COLOR controls the output colorization

# SEE ALSO

`logging::level(1)`, `logging::setlevel(1)`

for `info(1)` disambiguation:

builtin `command`, `info(1)`

    $ command [-pVv] info [arg ...]

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
