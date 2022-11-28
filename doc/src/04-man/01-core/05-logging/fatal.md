% FATAL(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

fatal - display a message and panic with an error code

# SYNOPSIS

fatal [*message* ...]

# DESCRIPTION

With *message* a string, `fatal` takes an arbitrary number of *message*
arguments.
*message* can be set in special variable `$__` or by calling `raise(1)`.

Each message is always displayed on its own.

`fatal` is an `errcode` handler, it returns previous `$?` unless a write
or assignment error occurs. If previous `$?` is 0, `fatal` defaults to 1.

# EXAMPLES

    $ fatal
    2022-11-07 16:50:12+0100 [fatal] bash:1|

    $ fatal "fatal message"
    2022-11-07 16:50:14+0100 [fatal] bash:1| fatal message

    $ __='preset fatal'; false \
    || fatal
    2022-11-07 16:52:11+0100 [fatal] bash:1| preset fatal

    $ false || fatal 'failure!'
    2022-11-07 16:53:44+0100 [fatal] bash:1| failure!

    $ false \
      || raise "${E_PARAM_ERR}" 'not good' \
      || fatal
    2022-11-07 16:59:33+0100 [fatal] bash:1| not good

# SEE ALSO

`logging::level(1)`, `logging::setlevel(1)`, `errcode::trap(1)`, `raise(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
