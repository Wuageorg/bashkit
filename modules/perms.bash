#!/usr/bin/env bash
# perms.bash --
# bashkit module
# permissions handling
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash perms\n'
    exit 1
fi

perms::init() {
    bashkit::load check
    debug done!
}

perms::mode() { # perms as "-rw-r--r--"
    symrex='^[-dclpsbDCMnP?]([-r][-w][-xsS]){2}([-r][-w][-xtT])[+]?'

    [[ $1 =~ ${symrex} ]] \
    || raise 'invalid symbolic mode'

    local p=${1:1}
    p=${p//[ST-]/0}
    p=${p//[!0]/1}

    printf -v __ '%04o\n' $((2#${p})) # perms as "0644"
    printf '%s\n' "${__}"
}

perms::gid() {
    check::cmd getent awk \
    || error

    local gid=$1  # gid as 'root'
    local num='^[0-9]+$'
    if ! [[ $1 =~ ${num} ]]; then
        gid=$( getent group "$1" | awk -F: '{printf "%d", $3}' )
    fi
    printf -v __ '%s' "${gid}" # gid as 0
    printf '%s\n' "${__}"
}

perms::uid() {
    check::cmd id \
    || error

    local uid=$1  # uid as 'root'
    local num='^[0-9]+$'
    if ! [[ $1 =~ ${num} ]]; then
        uid=$( id -u "$1" )
    fi
    printf -v __ '%s' "${uid}" # uid as 0
    printf '%s\n' "${__}"
}
