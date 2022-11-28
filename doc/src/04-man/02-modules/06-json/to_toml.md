% JSON::TO_TOML(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

json::to_toml - convert json to toml

# SYNOPSIS

json::to_toml *fd*

# DESCRIPTION

With *fd* a file descriptor, `json::to_toml` reads json from *fd*
and prints the resulting toml to `stdout`.

`json::to_toml` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ printf '%s\n' "${json}" | json::to_toml /dev/stdin

# SEE ALSO

`json::from_toml(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
