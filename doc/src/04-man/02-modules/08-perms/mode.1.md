---
title: PERMS::MODE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---


# NAME

perms::mode - convert symbolic file mode to absolute notation

# SYNOPSIS

perms::mode *mode*

# DESCRIPTION

With *mode* an absolute mode as defined in `chmod(1)`, `perms::mode`
convert it to its absolute representation.

`perms::mode` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ perms::mode "-rw-r--r--"
    0644

# SEE ALSO
`chmod(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
