% JSON::INTO_DICT(1) Bashkit User Manuals
% Wuage
% October 2022

# NAME

json::into_dict - load a json dictionary into a bash one

# SYNOPSIS

json::into_dict *D* *jdict*

# DESCRIPTION

With *D* an associative array variable and *jdict* a json dictionary,
`json::into_dict` loads *jdict* content into *D*. It does NOT recurse
because bash does not support nested dictionaries.

`json::into_dict` returns 0 upon success, >0 otherwise.

# EXAMPLE

    $ json='{"a": 3, "7": { "sub": [3, true, "x"] }}'
    $ declare -A D
    $ json::into_dict D <<< "${json}"
    $ echo "${!D[@]}
    a 7
    $ echo "${D[7]}"
    { "sub": [3, true, "x"] }

# SEE ALSO

`json::into_array(1)`

# COLOPHON
This page is part of the wuage bashkit framework. Source code and all
documentation maybe downloaded from <http://bashkit.wuage.org>

The `doc` directory distributed with `bashkit` contains full documentation.
