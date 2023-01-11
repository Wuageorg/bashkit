---
title: RAISE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

raise - raise or reraise an `errcode`

# SYNOPSIS

raise [*errcode*] [*errmsg*]

# DESCRIPTION

Raise set an *errcode* and an *errmsg* and then fails immediately.

Raise returns the given *errcode*. If the specified *errcode* is zero,
the exit status defaults to one. When no *errcode* is specified, `raise`
returns either the last positionned `errcode` or defaults to one if none.

If *errmsg* is not given, `raise` uses the last positionned one or
defaults to none.

# EXAMPLES

  **Example 1 Direct invocation**

  The following command always fails, here `raise` is equivalent to `false(1)`.

    $ raise

  **Example 2 Direct invocation with arguments**

  The first two commands fail with exit status 2, the last one with 1.
  In the last two, an error message is also positionned.

    $ raise 2
    $ raise 2 "error message"
    $ raise "error message"

  **Example 3 Raising last exit status**

  The following commands will raise the exit status returned by `rm(1)`
  along with an error message for the second one.

    $ rm "${TMPFILE}" \
      || raise
    $ rm "${TMPFILE}" \
      || raise "cannot rm ${TMPFILE}"

  **Example 4 Raising exit status through calling stack**

  The following script will log an error and then exit with status 1. The exit
  status is set in `isint` and reused upon return by `error(1)`.

    #!/usr/bin/env bash
    # isint.bash -- bashkit example
    source bashkit.bash

    isint() {
      local n
      printf -v n '%d' "${1:-}" &> /dev/null \
      || raise "not an int"
    }

    isint "abc" \
    || error

    $ bash isint.bash
    2022-10-31 20:44:01+0100 [error] isint:8| not an int

**Example 5 Relocating errors throughout calling points**

In the above example, the error message traced back into `isint`. It is
sometimes usefull to relocate the error at the calling point:

    #!/usr/bin/env bash
    # isint.bash -- bashkit example
    source bashkit.bash

    isint() {
      local n
      printf -v n '%d' "${1:-}" &> /dev/null \
      || raise "not an int"
    }

    isint "abc" \
    || raise \
    || error

    $ bash isint.bash
    2022-10-31 20:47:38+0100 [error] isint.bash:13| not an int

# SEE ALSO

`catch(1)`, `resume(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
