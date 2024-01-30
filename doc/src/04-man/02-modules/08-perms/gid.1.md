---
title: PERMS::GID
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

perms::gid - convert group name to gid

# SYNOPSIS

perms::gid *group*

# DESCRIPTION

With *group* a group name as given by `id -g`, `perms::gid` converts
it to a gid integer as given by `id -gn`.

`perms::gid` returns 0 upon success, >0 and logs an error otherwise.

# EXAMPLE

    $ perms::gid wheel
    0

# SEE ALSO

`id(1)`, `perms::uid(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
