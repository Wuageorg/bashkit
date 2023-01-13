---
title: CHECK::VARTYPE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

check::vartype - check variable attributes

# SYNOPSIS

check::vartype *attrs* *var*

# DESCRIPTION

With *attrs* an attribute string and *var* a variable, `check::vartype` checks
if *var* has set *attrs*. It does NOT check the content of *var*.

Some *attrs* are inherited from builtin `declare`:

| attr | description   |
|------|---------------|
| *a*  | indexed array |
| *A*  | dictionary    |
| *i*  | integer       |
| *l*  | lower case    |
| *n*  | nameref       |
| *r*  | readonly      |
| *t*  | trace         |
| *u*  | upper case    |
| *x*  | export        |

to which bashkit adds:

| attr | description   |
|------|---------------|
| *f*  | function      |
| *s*  | set           |

A *var* can be set to an empty value. When checking for a nameref and more,
*var* is dereferenced before checking for more *attrs* than *n*.

`check::vartype` returns 0 upon success, >0 otherwise.

# EXAMPLES

    $ declare -a ARR=()
    $ declare -n _A=ARR
    $ check::vartype nas _A && echo OK
    OK
    $ n=0  # no integer attribute
    $ check::vartype i n || echo NOK
    NOK

# SEE ALSO

builtin `declare`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.io>

The `doc` directory distributed with `bashkit` contains full documentation.
