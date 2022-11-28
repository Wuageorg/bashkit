% LOGGING::SETLEVEL(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

logging::setlevel - modify the current logging level

# SYNOPSIS

logging::setlevel [*level*]

# DESCRIPTION

With *level* either an integer in [0-7] or a string in:
  panic | emerg | alert | crit | error | warn | note | info | debug,
`logging::setlevel` sets the current script logging level.

If *level* is invalid, the logging level defaults to INFO/6.

`logging::setlevel` returns success.

# EXAMPLES

    $ logging::setlevel 7
    $ logging::setlevel debug

# SEE ALSO

`logging::level(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
