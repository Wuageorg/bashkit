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
        DIGIT='0|[1-9][0-9]*' \
        ALNUM='[0-9]*[A-Za-z-][0-9A-Za-z-]*' \
        FIELD='[0-9A-Za-z-]+'

    local IDENT="${DIGIT}|${ALNUM}"

    local SEMVER="^[vV]?(${DIGIT})\\.(${DIGIT})\\.(${DIGIT})(\\-(${IDENT})(\\.(${IDENT}))*)?(\\+${FIELD}(\\.${FIELD})*)?$"

    if [[ $1 =~ ${SEMVER} ]]; then
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
        raise "$1 does not match semver 'X.Y.Z(-PRERELEASE)(+BUILD)'."
    fi
}

semver::compare() {
    svc__cmp_digit() {
        __=0
        if (( $1 < $2 )); then { __=-1; }; fi
        if (( $1 > $2 )); then { __=1; }; fi
    }

    svc__cmp_str() {
        __=0
        if [[ $1 < $2 ]]; then { __=-1; }; fi
        if [[ $1 > $2 ]]; then { __=1; }; fi
    }

    svc__is_digit() {
        local DIGIT='0|[1-9][0-9]*'
        [[ $1 =~ ^(${DIGIT})$ ]]
    }

    # shellcheck disable=SC2250  # no {} for single letter vars
    svc__cmp_fields() {
        local aver="$1[@]"
        local bver="$2[@]"
        local \
            afields=( "${!aver}" ) \
            bfields=( "${!bver}" )

        __=0
        local i=0
        for((i=0; __ == 0; i++)); do
            local \
                a="${afields[i]:-}" \
                b="${bfields[i]:-}"

            if [[ -z "$a" && -z "$b" ]]; then
                break;
            elif [[ -z "$a" ]]; then
                __=-1
            elif [[ -z "$b" ]]; then
                __=1
            elif svc__is_digit "$a" && svc__is_digit "$b" ; then
                svc__cmp_digit "$a" "$b"
            elif svc__is_digit "$a"; then
                __=-1
            elif svc__is_digit "$b"; then
                __=1;
            else
                svc__cmp_str "$a" "$b";
            fi
        done
    }

    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    semver::parse "$1" \
    && local va=("${__[@]}") \
    || return

    semver::parse "$2" \
    && local vb=("${__[@]}") \
    || return

    # compare major, minor, patch
    local \
        a=( "${va[0]}" "${va[1]}" "${va[2]}" ) \
        b=( "${vb[0]}" "${vb[1]}" "${vb[2]}" )

    svc__cmp_fields a b
    if (( __ != 0 )); then
        return
    fi

    # compare pre-release ids when M.m.p are equal
    local \
        prerela="${va[3]}" \
        prerelb="${vb[3]}"

    # if a and b have no pre-release part, then a equals b
    # if only one of a/b has pre-release part, that one is less than simple M.m.p
    if [[ -z "${prerela}" && -z "${prerelb}" ]]; then
        __=0
    elif [[ -z "${prerela}" ]]; then
        __=1
    elif [[ -z "${prerelb}" ]]; then
        __=-1
    else
        # otherwise, compare the pre-release id's
        readarray -d' ' -t a < <(printf '%s' "${prerela//./ }")
        readarray -d' ' -t b < <(printf '%s' "${prerelb//./ }")
        svc__cmp_fields a b
    fi
}
