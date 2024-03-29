---
title: CHECK::DIR
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

check::dir - ensure a directory exists

# SYNOPSIS

check::dir [*dir* ...]

# DESCRIPTION

With *dir* a directory, `check::dir` ensures that it exists, if not it creates it.

`check::dir` returns 0 if *dir* exists or has been created, >0 otherwise.

# EXAMPLE

    $ check::dir /usr /tmp/mydir

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
