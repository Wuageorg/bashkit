---
title: URLENCODE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

urlencode - percent encode a string

# SYNOPSIS

urlencode *url*

# DESCRIPTION

`urlencode` is part of bashkit module `extras`, given an *url* string,
it displays a percent encoded version of it.

`urlencode` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ urlencode "https://github.com/dylanaraps/pure-bash-bible"
    https%3A%2F%2Fgithub.com%2Fdylanaraps%2Fpure-bash-bible

# SEE ALSO
`urldecode(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
