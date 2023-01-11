---
title: CATCH
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

catch - store a raising `errcode` and resume execution

# SYNOPSIS

catch [*refname*]

# DESCRIPTION

Catch captures and stores a raising `errcode` and then resume execution
at the first following command.

If no *refname* is specified, `errcode` is stored in special bashkit
variable `$____`.

When `catch` returns, the error context is modified:
`$?` is equal to 0.

Catch always returns with an exit code of zero.

# EXAMPLES

  **Example 1 `true(1)` equivalence**

  The following command will never fail, it is equivalent to using `true(1)`.

    $ rm "${TMPFILE}" || catch

  **Example 2 Error handling**

  The following command, in case of failure, will print an explanation for
  `curl(1)` exit statuses [1-3] or display it otherwise.

    $ curl "${URL}" > /dev/null 2>&1 || {
        catch rc;
        case ${rc} in
          1) echo "unsupported Protocol";;
          2) echo "failed to initialize";;
          3) echo "malformed URL";;
          *) echo "curl exited with status ${rc}";;
        esac
      }

# SEE ALSO

`raise(1)`, `resume(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
