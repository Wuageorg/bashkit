---
title: ERROR::CUSTOM
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

error::custom - register a custom error

# SYNOPSIS

error::custom *rawname* *rawcode*

# DESCRIPTION

With *rawname* a string and *rawcode* a positive integer in range [1-90],
`error::custom` registers `$E_<RAWNAME>` wich equals `$E_CUSTOM` + *rawcode*.

*rawname* is valid if it matches:
```
^E_([A-Z1-9]+)((_([A-Z1-9])+)*)$
```

`error::custom` returns 0 if successful. It returns `$E_PARAM_ERR` when
*rawname* or *rawcode* are already defined or if *rawcode* is out of range.

# EXAMPLE

    $ error::custom empty_buffer 1
    $ echo "${__}"
    E_EMPTY_BUFFER=33
    $ echo ${E_EMPTY_BUFFER}
    33

# SEE ALSO

`error::class(1)`, `error::list(1)`, `error::whatis(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
