---
title: COLOR::IS_ENABLED
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

color::is_enabled - test if color is supported

# SYNOPSIS

color::is_enabled

# DESCRIPTION

`color::is_enabled` test if color is not *disabled* and terminal is compatible.
One can *disable* color by setting `$NO_COLOR` before running scripts.

`color::is_enabled` returns 0 if colors are available and >0 otherwise.

# EXAMPLE

    $ color::is_enabled && echo "colors are available" || resume echo "no color"

# SEE ALSO

`color::encode(1)`, `color::table(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
