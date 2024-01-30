---
title: CHECK::CMD
section: 1
header: Bashkit User Manual
footer: RC
date: October 2022
---

# NAME

check::cmd - check if a command is available

# SYNOPSIS

check::cmd [*cmd* ...]

# DESCRIPTION

With a list of *cmd*, `check::cmd` verify that *cmd* is executable.

`check::cmd` returns 0 if *cmd* is executable, >0 otherwise.

# EXAMPLE

    $ check::cmd ls cat && echo "ls and cat are available"
    ls and cat are available

# AUTHORS
Written by \\Nuage

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <https://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
