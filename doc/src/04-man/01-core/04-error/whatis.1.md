---
title: ERROR::WHATIS
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

error::whatis - bidirectional mapper between error codes and names

# SYNOPSIS

error::whaits *error*

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

The queried error code/name is printed on `stdout` *and* stored in special variable `$__`.

`error::whatis` returns 0 on success >0 otherwise.

# EXAMPLES

    $ error::whatis 129
    E_SIGHUP
    $ error::class E_SIGHUP
    129


# SEE ALSO

`error::class`, `error::custom(1)`, `error::list(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
