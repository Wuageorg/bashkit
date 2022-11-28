% NOT(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

not - unary logical not as a function

# SYNOPSIS

not [*command*]

# DESCRIPTION

`not` is the functional equivalent of `!`. It is intended to be used with
`resume(1)` that can only accept a command as argument.

# EXAMPLES

  Example 1 Direct invocation

  The first following command always fails while the second always succeeds.

    $ not true
    $ not false

  Example 2 Combining with `resume(1)`

  The following command is equivalent to logical `(green | ! red)`:

    $ is_green "${color}" || resume not is_red "${color}"

# SEE ALSO

`resume(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
