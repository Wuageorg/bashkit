#!/usr/bin/env bash
# readlinkf.bash --
# source: ko1nksm/readlinkf <https://github.com/ko1nksm/readlinkf>
#
# changes from the original:
# - does not output newline
# - runs in subshell
# - refactored tests from [] to [[ ]]
# - loop turned from while to for
# - bashkit compatibe
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

# bashkit port of POSIX compliant readlinkf
readlinkf() (  # subshell
    target=$1
    if [[ -e  ${target%/} ]]; then
        target=${1%"${1##*[!/]}"}
    fi

    if [[ -d "${target:-/}" ]]; then
        target="${target}/"
    fi

    cd -P . 2> /dev/null \
    || return 1

    local max=40 nlink  # symlinks count
    for (( nlink=0; nlink < max; nlink++ )) do
        if [[ ! ${target} = "${target%/*}" ]]; then
            case ${target} in
                /*) cd -P "${target%/*}/" 2>/dev/null \
                    || break ;;
                *)  cd -P "./${target%/*}" 2>/dev/null \
                    || break ;;
            esac
            target=${target##*/}
        fi

        if [[ ! -L ${target} ]]; then
            target=${PWD%/}${target:+/}${target}
            printf '%s' "${target:-/}"
        return 0
        fi

        # `ls -dl` format: "%s %u %s %s %u %s %s -> %s\n",
        #   <file mode>, <number of links>, <owner name>, <group name>,
        #   <size>, <date and time>, <pathname of link>, <contents of link>
        # https://pubs.opengroup.org/onlinepubs/9699919799/utilities/ls.html
        link=$(ls -dl -- "${target}" 2>/dev/null) \
        || break
        target=${link#*" ${target} -> "}
  done

  return 1  # more than max symlinks
)
