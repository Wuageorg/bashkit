% PROGRESS(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

progress - display a progress bar

# SYNOPSIS

progress *percent* *total*

# DESCRIPTION

`progress` is part of bashkit module `extras`, given two integers *percent* and *total*,
it displays a progress bar. This bar has a len of *total* dashes.

# EXAMPLE

      $ for (( i=0; i<=100; i++ )); do
      >   usleep 5
      >   progress "${i}" 20
      > done
      > printf '\n'
      [--------------------]

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
