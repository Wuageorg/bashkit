% RESUME(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

resume - abort a raising `errcode` and resume execution

# SYNOPSIS

resume [*command*]

# DESCRIPTION

Unlike `catch(1)`, `resume` executes in the *same context* as the error.
It allows the flow of control to abort the raising `errcode` and to recover
execution by running the command that follows it.

# EXAMPLES

  Example 1 Direct invocation

  The following command always succeed, here `resume` is equivalent to
  builtin `:`.

    $ resume

  Example 2 Direct invocation with a command argument

  The following command displays a message, here `resume` is a no-op:

    $ resume echo "resumed!"

  Example 3 Error flow of control handling

    $ (( n > 0 && n & 0x1 )) && echo "odd" || resume echo "even"

  Without `resume` the above command will stop short *before* `||` for any
  even number: it will not display "even".

  Example 4 Combining with `not(1)` or builtin `let`

  `resume` argument must be a *command*, unary operator or litteral values
  are not supported. This is why we have to use `not(1)` in the following
  construct:

    $ is_green "${color}" || resume not is_red "${color}"

  The same goes for assignations:

    $ is_even "${x}" || resume let x=$((x + 1))

# SEE ALSO

`catch(1)`, `raise(1)`, `not(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
