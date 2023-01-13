---
title: CLEANUP
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

cleanup - hook a command to the EXIT signal

# SYNOPSIS

cleanup [*arg*]

# DESCRIPTION

`cleanup` is a wrapper to bashkit `trap::callback` on the EXIT signal.

*arg* is defined in bash builtin trap help.

Upon reception of EXIT, the commands are executed in LIFO order.

# EXAMPLES

    $ cleanup "echo goodbye world!"
    goodbye world!
    $ touch /tmp/tmpfile && cleanup 'rm -f /tmp/tmpfile'

# SEE ALSO

builtin `trap`, `trap::callback(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
