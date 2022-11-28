% BREAKPOINT(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

breakpoint - set an intentional pausing place for debugging purpose

# SYNOPSIS

breakpoint

# DESCRIPTION

When used in conjunction of `errcode::trap breakpoint` mode or if
`$DEBUG` is set beforehand, `breakpoint` pauses the script runtime and
throws a minimal console to the controlling tty `/dev/tty`. Otherwise,
`breakpoint` is a no op.

# EXAMPLE

    $ errcode::trap breakpoint
    $ breakpoint
    # breakpoint (0)
    debug>

# SEE ALSO

`errcode::trap(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
