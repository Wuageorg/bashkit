---
title: JSON::TO_TOML
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

json::to_toml - convert json to toml

# SYNOPSIS

json::to_toml *fd*

# DESCRIPTION

With *fd* a file descriptor, `json::to_toml` reads json from *fd*
and prints the resulting toml to `stdout`.

`json::to_toml` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ printf '%s\n' "${json}" | json::to_toml /dev/stdin

# SEE ALSO

`json::from_toml(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
