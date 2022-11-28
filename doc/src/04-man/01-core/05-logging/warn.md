% WARN(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

warn - display a warn message

# SYNOPSIS

warn [*message* ...]

# DESCRIPTION

With *message* a string, `warn` takes an arbitrary number of *message*
arguments.
*message* can be set in special variable `$__`.

If `$LOGLEVEL` is >= 4 beforehand or set at runtime each message
is displayed on its own.

`warn` returns success unless a write or assignment error occurs.

# EXAMPLES

    $ warn
    2022-11-08 00:59:32+0100 [warn] bash:1|

    $ warn "warn message"
    2022-11-08 01:00:03+0100 [warn] bash:1| warn message

    $ __='preset message' && warn
    2022-11-08 01:00:57+0100 [warn] bash:1| preset message

# SEE ALSO

`logging::level(1)`, `logging::setlevel(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
