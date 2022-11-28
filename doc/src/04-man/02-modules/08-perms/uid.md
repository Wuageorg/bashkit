% PERMS::UID(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

perms::uid - convert user name to uid

# SYNOPSIS

perms::uid *user*

# DESCRIPTION

With *user* a user name as given by `id -u`, `perms::uid` converts
it to an uid integer as given by `id -un`.

`perms::uid` returns 0 upon success, >0 and logs an error otherwise.

# EXAMPLE

    $ perms::uid root
    0

# SEE ALSO

`id(1)`, `perms::gid(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
