---
title: PATCH::APPLY
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

patch::apply - apply a patch

# SYNOPSIS

patch::apply *dir* *patch*

# DESCRIPTION

Witn *dir* a destination directory and *patch* a patch file,
`patch::apply` applies modification from *patch* to *dir* files.

`patch::apply` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ patch::apply "${DIR}" "a.patch"

# SEE ALSO

`diff(1)`, `patch(1)`, `patch::batch(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
