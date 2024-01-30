---
title: SEMVER::PARSE
section: 1
header: Bashkit User Manual
footer: RC
date: January 2023
---

# NAME

semver::parse - parse a semantic version string and return major, minor, patch, pre-release, and build information

# SYNOPSIS

semver::parse [string]

# DESCRIPTION

`semver::parse` parses a semantic version string and returns major, minor, patch, pre-release, and build information. The input string must be in the format of "X.Y.Z(-PRERELEASE)(+BUILD)".
The function checks the input string against a regular expression to ensure the proper format. If the input string does not match the format, the function raises an error.
The returned information is stored in `__`, with the following elements:

    ${__[0]} - major version
    ${__[1]} - minor version
    ${__[2]} - patch version
    ${__[3]} - pre-release version
    ${__[4]} - build version

# EXAMPLE

    $ semver::parse "v1.2.3-alpha.1+build.42"
    $ echo "${__[0]}"  # output: 1
    $ echo "${__[3]}"  # output: alpha.1

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
