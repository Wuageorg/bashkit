% INTERACTIVE::YESNO(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

interactive::yesno - ask a yes/no question to the user

# SYNOPSIS

interactive::yesno *question* [*default*]

# DESCRIPTION

`interactive::yesno` displays *question* and wait for the user to
answer, if *default* is given, it is used if the user simply
presses `ENTER`.

`interactive::yesno` returns 0 when user answers `yes`, >0 otherwise

# EXAMPLE

    $ interactive::yesno "are you happy?" y
    are you happy? [YES/no]:


# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
