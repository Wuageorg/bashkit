#!/usr/bin/env bash
# semver.bash --
# bashkit module
# ----
# SPDX-License-Identifier: Apache-2.0
# Adapted from https://github.com/fsaintjacques/semver-tool/blob/master/src/semver

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed
# shellcheck disable=SC2178 # allow to change __ type

if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash %s instead of source %s\n' "${0%%*.}" "$0"
    exit 1
fi

semver::init() {
    :
}

semver::parse() {
    (( $# == 1 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local \
        NAT='0|[1-9][0-9]*' \
        ALPHANUM='[0-9]*[A-Za-z-][0-9A-Za-z-]*' \
        FIELD='[0-9A-Za-z-]+'

    local IDENT="${NAT}|${ALPHANUM}"

    local SEMVER_REGEX="^[vV]?(${NAT})\\.(${NAT})\\.(${NAT})(\\-(${IDENT})(\\.(${IDENT}))*)?(\\+${FIELD}(\\.${FIELD})*)?$"


    local version=$1
    if [[ ${version} =~ ${SEMVER_REGEX} ]]; then
        local \
            major=${BASH_REMATCH[1]} \
            minor=${BASH_REMATCH[2]} \
            patch=${BASH_REMATCH[3]} \
            prere=${BASH_REMATCH[4]} \
            build=${BASH_REMATCH[8]}
        prere=${prere:1} # remove leading -
        build=${build:1} # remove leading +
        __=("${major}" "${minor}" "${patch}" "${prere}" "${build}")
    else
        raise "version ${version} does not match the semver scheme 'X.Y.Z(-PRERELEASE)(+BUILD)'."
    fi
}


semver::compare() {
    semver__order_nat() {
        if [[ "$1" -lt "$2" ]]; then { __=-1 ; return ; }; fi
        if [[ "$1" -gt "$2" ]]; then { __=1  ; return ; }; fi
        __=0
    }

    semver__order_string() {
        if [[ $1 < $2 ]]; then { __=-1 ; return ; }; fi
        if [[ $1 > $2 ]]; then { __=1 ; return ; }; fi
        __=0
    }

    semver__is_nat() {
        local NAT='0|[1-9][0-9]*'
        [[ "$1" =~ ^(${NAT})$ ]]
    }

    semver__compare_fields() {
        local l="$1[@]"
        local r="$2[@]"
        local \
            leftfield=(  "${!l}" ) \
            rightfield=( "${!r}" )
        local left right

        local i=0
        __=0

        while true; do
            # shellcheck disable=SC2128 # __ not an array here
            if [[ ${__} -ne 0 ]]; then return; fi

            left="${leftfield[i]:-}"
            right="${rightfield[i]:-}"

            i=$(( i + 1 ))

            if   [[ -z "${left}" ]] && [[ -z "${right}" ]]; then
                __=0; return;
            elif [[ -z "${left}" ]]                     ; then
                __=-1 ; return;
            elif [[ -z "${right}" ]]                    ; then
                __=1  ; return;
            elif semver__is_nat "${left}" && semver__is_nat "${right}" ; then
                semver__order_nat "${left}" "${right}"; continue;
            elif semver__is_nat "${left}"; then
                __=-1; return;
            elif semver__is_nat "${right}"; then
                __=1;  return;
            else
                semver__order_string "${left}" "${right}"; continue;
            fi
        done
    }

    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local va vb
    semver::parse "$1" || return
    va=("${__[@]}")
    semver::parse "$2" || return
    vb=("${__[@]}")

    # compare major, minor, patch

    local left=(  "${va[0]}" "${va[1]}" "${va[2]}" )
    local right=( "${vb[0]}" "${vb[1]}" "${vb[2]}" )

    semver__compare_fields left right
    # shellcheck disable=SC2128 # __ not an array here
    if [[ "${__}" -ne 0 ]]; then
        return
    fi

    # compare pre-release ids when M.m.p are equal
    local prerela="${va[3]}"
    local prerelb="${vb[3]}"
    readarray -d' ' -t left  < <(printf '%s' "${prerela//./ }")
    readarray -d' ' -t right < <(printf '%s' "${prerelb//./ }")

    # if left and right have no pre-release part, then left equals right
    # if only one of left/right has pre-release part, that one is less than simple M.m.p

    if [[ -z "${prerela}" && -z "${prerelb}" ]]; then
        __=0  ; return ;
    elif [[ -z "${prerela}" ]]; then
        __=1; return;
    elif [[ -z "${prerelb}" ]]; then
        __=-1; return;
    fi

    # otherwise, compare the pre-release id's
    semver__compare_fields left right
}
