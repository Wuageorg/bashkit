% ERRCODE::TRAP(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

errcode::trap - get or set `errcode` mode

# SYNOPSIS

errcode::trap [*command*]

# DESCRIPTION

*command* is one of `default` | `enable` | `disable` | `breakpoint` | `status`.
If no *command* is given, it defaults to `status`. `errcode::trap` panics by
calling `fatal(1)` otherwise.

`errcode::trap` returns with an exit code of zero if a `errcode`
is enabled, >0 otherwise.

*Disabling `errcode` `trap` is strongly discouraged as it may result in non obvious
bad script side effects*.

# EXAMPLE

    $ errcode::trap \
    && echo "errcode trap is enabled" \
    || resume echo "errcode is disabled"
    errcode is enabled

# SEE ALSO

`breakpoint(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloadeded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
