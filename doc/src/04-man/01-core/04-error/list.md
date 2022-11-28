% ERROR::LIST(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

error::list - error class listing tool

# SYNOPSIS

error::list *errclass*

# DESCRIPTION

With *errclass* is one of `all` | `bash` | `bashkit` | `custom` | `signal`.
When *errclass* is not given it defaults to `all`. `error::list` panics by
calling `fatal(1)` otherwise.

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

The queried error list is printed on `stdout`.

`error::list` always returns 0 unless invoked with a bad *errclass*.

# EXAMPLE

    $ error::list | column -t -s "="
    E_SUCCESS            0
    E_FAILURE            1
    ...
    E_SIGRTMAX           192


# SEE ALSO

`error::class(1)`, `error::custom(1)`, `error::whatis(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
