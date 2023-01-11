---
title: STRING::SPLIT
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

string::split - extract substrings delimited by a separator from string

# SYNOPSIS

string::split *str* *sep*

# DESCRIPTION

With *str* and *sep*, two strings, `string::split`
splits *str* on *sep* occurences.

# EXAMPLE

    $ string::split 'apples,oranges,pears,grapes' ','
    apples oranges pears grapes

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
