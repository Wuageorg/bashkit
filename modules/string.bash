#!/usr/bin/env bash
# string.bash --
# bashkit module
# implements useful string routines
# adapted from https://github.com/dylanaraps/pure-bash-bible#strings
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

string::lstrip() {
    printf '%s\n' "${1##"$2"}"
}

string::regex() {
    if [[ $1 =~ $2 ]]; then
        printf '%s\n' "${BASH_REMATCH[1]}"
        return 0
    fi
    return 1
}

string::rstrip() {
    printf '%s\n' "${1%%"$2"}"
}

string::split() {
    local -a A
    readarray -d $'\n' -t A < <(printf '%s' "${1//$2/$'\n'}")
    printf '%s\n' "${A[@]}"
}

string::strip() {
    printf '%s\n' "${1/$2}"
}

string::stripall() {
    printf '%s\n' "${1//$2}"
}

string::trim() {
    local s="${1#"${1%%[![:space:]]*}"}"
    printf '%s\n' "${s%"${s##*[![:space:]]}"}"
}
