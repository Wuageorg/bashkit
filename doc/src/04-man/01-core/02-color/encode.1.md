---
title: COLOR::ENCODE
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

color::encode - compute an 8 colors ANSI code from a color description

# SYNOPSIS

color::encode [*description*]

# DESCRIPTION

`color::encode` encodes a color description into an ANSI color escape code.
The code is always stored in special bashkit variable `$__`.

If no *description* is specified, the code defaults to `ESC[m`, the reset code.

The description must be written according to the following grammar:

```
description = color "text" [ color "background" ]
            | "reset"

color = ""
      | attributes brightness base

attributes=? a list of unique modifiers ?

modifiers = ""
          | "regular" | "bold" | "dim" | "italic" | "underlined" | "blinking"
          | modifiers, { modifiers }

brightness = ""
           | "bright"

base = "black" | "red" | "green" | "yellow"
     | "blue" | "magenta" | "cyan" | "white"
     | "default"
```
The smallest descriptions of all are `"text"` and `"reset"`.
The later is always the ANSI `ESC[m` reset code while the former is the
current system-defined default.

`color::encode` returns with an exit code of zero upon successful encoding. It
returns `E_PARAM_ERR/9` otherwise.

# EXAMPLES

The description must always be written without quote when invoking directly:
```
  $ color::encode underlined blinking bold white text red background
  $ echo "${__}"
  \x1b[4;5;1;37;41m
```

# SEE ALSO

https://en.wikipedia.org/wiki/ANSI_escape_code

`color::table(1)`

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
