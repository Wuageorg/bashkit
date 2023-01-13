---
title: COLOR::TABLE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

color::table - compute 8 colors ANSI code from a description dictionary

# SYNOPSIS

color::table [*dict*]

# DESCRIPTION

`color::table` replaces descriptions found in an associative array by
corresponding ASCII 8-color codes. The *dict* can subsequently be used
as a `lookup table`.

The descriptions must be written for `color::encode(1)`.

If there is a type mismatch or if *dict* is undefined, `color::table`
panics by calling `fatal(1)`.

`color::table` returns with an exit code of zero upon successful encoding. It
errors with exit status `E_PARAM_ERR/9` otherwise. The content of the original
dict is undefined in the later case.

# EXAMPLE

```
$ declare -A COLPAL=(  # color palette
    [panic]='underlined blinking bold white text red background'
    [alert]='bold white text red background'
    [crit]='underlined bold red text'
    [fatal]='bold red text'
    [error]='red text'
    [warn]='yellow text'
    [note]='blue text'
    [info]='green text'
    [debug]='magenta text'
    [reset]='reset'
  )
$ color::table COLPAL
$ echo "${COLPAL[panic]}"
\x1b[4;5;1;37;41m
```

# SEE ALSO

`color::encode(1)`, `error(1)`, `fatal(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
