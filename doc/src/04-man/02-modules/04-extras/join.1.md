---
title: JOIN
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

join - build a string of arguments separated by a given character

# SYNOPSIS

join *sep* *arg* [*arg* ...]

# DESCRIPTION

`join` is part of bashkit module `extras`, given *sep* a single
character and *arg* a list of arbitrary strings, it builds a
string with all *args* separated by *sep*.

# EXAMPLES
      $ join "," a b c d
      a,b,c,d
      $ join ":" a
      a

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
