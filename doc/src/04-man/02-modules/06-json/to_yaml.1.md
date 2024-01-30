---
title: JSON::TO_YAML
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

json::to_yaml - convert json to toml

# SYNOPSIS

json::to_yaml *fd*

# DESCRIPTION

With *fd* a file descriptor, `json::to_yaml` reads json from *fd*
and prints the resulting yaml to `stdout`.

`json::to_yaml` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ printf '%s\n' "${json}" | json::to_yaml /dev/stdin

# SEE ALSO

`json::from_yaml(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
