% CRIT(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

crit - display a critical message

# SYNOPSIS

crit [*message* ...]

# DESCRIPTION

With *message* a string, `crit` takes an arbitrary number of *message*
arguments.
*message* can be set in special variable `$__` or by calling `raise(1)`.

If `$LOGLEVEL` is >= 2 beforehand or set at runtime each message argument
is displayed on its own.

`crit` is an `errcode` handler, it returns previous `$?` unless a write
or assignment error occurs.

# EXAMPLES

    $ crit
    2022-11-07 16:50:12+0100 [crit] bash:1|

    $ crit "crit message"
    2022-11-07 16:50:14+0100 [crit] bash:1| crit message

    $ __='preset error'; false \
    || crit
    2022-11-07 16:52:11+0100 [crit] bash:1| preset error

    $ false || crit 'failure!'
    2022-11-07 16:53:44+0100 [crit] bash:1| failure!

    $ false \
      || raise "${E_PARAM_ERR}" 'not good' \
      || crit
    2022-11-07 16:59:33+0100 [crit] bash:1| not good

# SEE ALSO

`logging::level(1)`, `logging::setlevel(1)`, `errcode::trap(1)`, `raise(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
