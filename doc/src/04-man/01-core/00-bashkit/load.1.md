---
title: BASHKIT::LOAD
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

bashkit::load - load a bashkit module

# SYNOPSIS

note [*modname* ...]

# DESCRIPTION

With *modname* a string, `bashkit:load` takes an arbitrary number of *modname*
arguments. *modname* refers to a module named `<modname>.bash` lying in the
hierarchy pointed by the environement variable $BASHKIT_MODPATH.

`bashkit::load` returns success unless the module does not exist.

# EXAMPLES

    $ bashkit load array

# ENVIRONMENT

- $BASHKIT_MODPATH points to the modules location

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
