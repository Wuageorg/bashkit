---
title: URLDECODE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

urldecode - percent decode a string

# SYNOPSIS

urldecode *url*

# DESCRIPTION

`urldecode` is part of bashkit module `extras`, given a percent-encoded *url*,
it restores it to its original form.

`urldecode` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ urldecode "https%3A%2F%2Fgithub.com%2Fdylanaraps%2Fpure-bash-bible"
    https://github.com/dylanaraps/pure-bash-bible

# SEE ALSO
`urlencode(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
