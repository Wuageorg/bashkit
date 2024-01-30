---
title: PANIC
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

panic - display a message and panic with error code 1

# SYNOPSIS

panic [*message* ...]

# DESCRIPTION

With *message* a string, `panic` takes an arbitrary number of *message*
arguments.
*message* can be set in special variable `$__` or by calling `raise(1)`.

Each message is always displayed on its own.

`panic` is an `errcode` handler, it returns 1.

# EXAMPLES

    $ panic
    2022-11-07 16:50:12+0100 [panic] bash:1|

    $ panic "panic message"
    2022-11-07 16:50:14+0100 [panic] bash:1| panic message

    $ __='preset panic'; false \
    || panic
    2022-11-07 16:52:11+0100 [panic] bash:1| preset panic

    $ false || panic 'failure!'
    2022-11-07 16:53:44+0100 [panic] bash:1| failure!

    $ false \
      || raise "${E_PARAM_ERR}" 'not good' \
      || panic
    2022-11-07 16:59:33+0100 [panic] bash:1| not good

# ENVIRONMENT

- $JSON controls the output format
- $LOGLEVEL controls the logging level
- $NO_COLOR controls the output colorization

# SEE ALSO

`logging::level(1)`, `logging::setlevel(1)`, `errcode::trap(1)`, `raise(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
