% TRAP::CALLBACK(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

trap::callback - hook a command to a signal

# SYNOPSIS

trap::callback [[*arg*] *signal_spec* ...]

# DESCRIPTION

`trap::callback` is a wrapper to bash builtin trap that goes the extra mile of
stacking up *arg* to already hooked up commands.

*arg* and *signal_spec* are defined in builtin `trap` help.

Upon reception of *signal_spec*, the commands are executed in LIFO order.

# EXAMPLE

    $ trap::callback "echo goodbye world!" EXIT
    goodbye world!

# SEE ALSO

builtin `trap`, `cleanup(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
