---
title: BREAKPOINT
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---
# NAME

breakpoint - set an intentional pausing place for debugging purpose

# SYNOPSIS

breakpoint

# DESCRIPTION

When used in conjunction of `errcode::trap breakpoint` mode or if
`$DEBUG` is set beforehand, `breakpoint` pauses the script and
throws a minimal console to `/dev/tty`. Otherwise,
`breakpoint` is a no-op.

# EXAMPLE

    $ errcode::trap breakpoint
    $ breakpoint
    # breakpoint (0)
    debug>

# SEE ALSO

`errcode::trap(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
