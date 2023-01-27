% VERSION::BASHKIT(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

version::bashkit - get current bashkit version

# SYNOPSIS

version::bashkit [VAR]

# DESCRIPTION

The version is stored in special bashkit variable `$__` or in `$VAR` if present.

`version::bashkit` creates a semver compatible version string in the form
`compat.date.commit[.branch][.hash]`.

- `compat` compatibility, is changed in case of breaking changes
- `date`   month and year release date, inform on available features
- `commit` unique version number
- `branch` only if not default, which branch was used to release bashkit
- `hash`   only if local files changed, see `state(1)`

# EXAMPLE

    $ version::bashkit && echo "${__}"
    1.2210.230

# SEE ALSO

`version::state(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
