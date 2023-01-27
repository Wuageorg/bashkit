---
title: SEMVER::COMPARE
section: 1
header: Bashkit User Manual
footer: RC
date: January 2023
---

# NAME

semver::compare - compare two semantic version strings and return the result

# SYNOPSIS

semver::compare [V1] [V2]

# DESCRIPTION

`semver::compare` compares two semantic version strings, V1 and V2, and returns the result in the form of an integer.

The comparison result is stored in the variable `__`. A value of 0 indicates that the input strings are equal, a value of 1 indicates that the first input string is greater than the second input string, and a value of -1 indicates that the first input string is less than the second input string.

# EXAMPLE

    $ semver::compare "1.2.3-alpha.1+build.42" "1.2.3-beta.1+build.42"
    $ echo "${__}"  # output: -1

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
