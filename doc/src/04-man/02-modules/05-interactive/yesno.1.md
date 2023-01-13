---
title: INTERACTIVE::YESNO
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

interactive::yesno - ask a yes/no question to the user

# SYNOPSIS

interactive::yesno *question* [*default*]

# DESCRIPTION

`interactive::yesno` displays *question* and wait for the user to
answer, if *default* is given, it is used if the user simply
presses `ENTER`.

`interactive::yesno` returns 0 when user answers `yes`, >0 otherwise

# EXAMPLE

    $ interactive::yesno "are you happy?" y
    are you happy? [YES/no]:

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
