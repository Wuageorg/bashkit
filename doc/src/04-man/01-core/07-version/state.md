% VERSION::STATE(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

version::state - get local bashkit version state

# SYNOPSIS

version::state [VAR]

# DESCRIPTION

The state is stored in special bashkit variable `$__` or in `$VAR` if present.

`version::state` outputs a string containing local files version information,
and is the input of `hash` version field see `version::bashkit(1)`.

`version::state` outputs nothing if local files are not modified.

# EXAMPLE

    $ version::state && echo "${__}"
    changed_version.bash ...

# SEE ALSO

`version::bashkit(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
