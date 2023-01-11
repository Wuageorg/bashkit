---
title: LOGGING::LEVEL
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

logging::level - display the current logging level

# SYNOPSIS

logging::level

# DESCRIPTION

`logging::level` displays the current script logging level on `stdout`.

It returns success unless a write or assignment error occurs.

# EXAMPLES

    $ logging::level
    6

# ENVIRONMENT

- $LOGLEVEL controls the logging level

# SEE ALSO

`logging::setlevel(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
