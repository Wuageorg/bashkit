---
title: CURL::DOWNLOAD
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

curl::download - download a file from an URL and print stats

# SYNOPSIS

curl::download *url* *dest*

# DESCRIPTION

With *dest* being a filename, `curl::download` prints a downloading digest
that contains the size and md5 hash of the downloaded file.

In baskhit, `curl` hence `curl::download` are preset with:
| option          | value |
|-----------------|-------|
| connect-timeout | 5     |
| continue-at     | -     |
| fail            |       |
| location        |       |
| retry           | 5     |
| retry-delay     | 0     |
| retry-max-time  | 40    |
| show-error      |       |
| silent          |       |

`curl::download` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ curl::download http://example.com "${tmpfile}"

# SEE ALSO

`curl(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
