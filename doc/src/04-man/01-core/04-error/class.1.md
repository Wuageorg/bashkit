---
title: ERROR::CLASS
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

error::class - error classifying tool

# SYNOPSIS

error::class *error*

# DESCRIPTION

With *error* either a positive integer in range [0-255] or a valid name:
```
^E_([A-Z1-9]+)((_([A-Z1-9])+)*)$
```

| range | names | owner | note |
|---|---|---|---|
0-3 | E_SUCCESS - E_UNSUPPORTED | bash
4-7 | N/A| unused
8-32 | E_BASHKIT - E_CUSTOM | bashkit | highest bit is 3 or 4
33-123| custom names | user | highest bit is 5 or 6 but lesser than 124
124-128| E_TIMEOUT - E_INVALID_EXIT | bash
129-192| E_SIGHUP - E_SIGRTMAX | signal | highest bit is 7 low bits for signum
193-254| N/A | unused
255| E_OUT_OF_RANGE | bash

The queried error class is printed on `stdout` *and* stored in special variable `$__`.

`error::class` returns 0 on success >0 otherwise.

# EXAMPLES

    $ error::class 129
    signal
    $ error::class E_SIGHUP
    signal


# SEE ALSO

`error::custom(1)`, `error::list(1)`, `error::whatis(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
