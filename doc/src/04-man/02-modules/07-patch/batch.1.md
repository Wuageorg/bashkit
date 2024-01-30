---
title: PATCH::BATCH
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

patch::batch - apply all patches from a patch directory onto files in a target directory

# SYNOPSIS

patch::batch *target* *patches*

# DESCRIPTION

Witn *target* a destination directory and *patches* a patch directory,
`patch::batch` applies modification from *patches* to *target* files.

`patch::batch` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ patch::batch "${TARGET_DIR}" "${PATCH_DIR}"

# SEE ALSO

`diff(1)`, `patch(1)`, `patch::apply(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
