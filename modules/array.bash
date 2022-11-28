#!/usr/bin/env bash
# array.bash --
# bashkit module
# array & dict useful routines
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck disable=SC2178 # shellcheck gets confused by refnames
# see https://github.com/koalaman/shellcheck/issues/2060


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash array\n'
    exit 1
fi

array::init() {
    bashkit::load check shopt
    debug done!
}

# return 0 if array contains x, otherwise return 1
# index of x is stored in $__
array::contains() {
    (( 1 < $# && $# < 4 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1
    local -n __acc=${3:-__}
    local x=$2

    check::vartype as __A \
    || raise \
    || return $?  # if no errcode trap

    local i
    __acc="${x} not found"
    for i in "${!__A[@]}"; do
        if [[ ${__A[i]} = "${x}" ]]; then
            __acc=${i}
            return 0  # found index of x in __A
        fi
    done
    raise \
    || return $?
}

# intersect arrays in O(n+m)
array::inter() {
    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1
    local -n __B=$2

    check::vartype a __A \
    && check::vartype a __B \
    || raise \
    || return $?

    local i
    local -A K
    # map A elements into K keys in O(n)
    for i in "${!__A[@]}"; do
        K+=( [${__A[i]}]=i )
    done

    local x
    local -a INTER
    # match B elements against K in O(m)
    for x in "${__B[@]}"; do
        if [[ -v K[${x}] ]]; then
            INTER+=( "${x}" )
        fi
    done

    __A=( "${INTER[@]}" )
}

array::map() {
    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1
    local fun=$2

    check::vartype a __A \
    && check::vartype f fun \
    || raise \
    || return $?  # if no errcode trap

    local x item
    local -a TMP
    for x in "${__A[@]}"; do
        item=$( "${fun}" "${x}" ) \
        || raise 1 "failed \$fun item=${x} (1)" \
        || return $?

        TMP+=( "${item}" )
    done

    __A=( "${TMP[@]}" )
}

array::pick() {
    (( $# == 1 || $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1
    local -n __acc=${2:-__}

    check::vartype as __A \
    || raise \
    || return $?  # if no errcode trap

    (( ${#__A[@]} != 0 )) \
    || raise "${E_PARAM_ERR}" 'empty array' \
    || return $?

    local i=$(( RANDOM % ${#__A[@]} ))
    printf -v __acc '%s\n' "${__A[i]}"
}

array::pop() {
    (( $# == 1 || $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    array::popi "$1" -1 "${2:-__}" \
    || raise \
    || return $?
}

array::popi() {
    (( $# == 3 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1
    local i=$2
    local -n __acc=$3

    check::vartype as __A \
    || raise \
    || return $?  # if no errcode trap

    (( ${#__A[@]} != 0 )) \
    || raise "${E_PARAM_ERR}" 'empty array' \
    || return $?

    (( -${#__A[@]} <= i && i < ${#__A[@]} )) \
    || raise "${E_PARAM_ERR}" 'out of range index'

    __acc=${__A[i]}
    unset '__A[i]'
}

array::push() {
    (( $# >= 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local x
    local -n __A=$1 && shift

    check::vartype a __A \
    || raise \
    || return $?  # if no errcode trap

    __A+=( "$@" )
}

array::shift() {
    (( $# == 1 || $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    array::popi "$1" 0 "${2:-__}" \
    || raise \
    || return $?  # if no errcode trap
}

array::unshift() {
    (( $# >= 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1 && shift

    check::vartype a __A \
    || raise \
    || return $?  # if no errcode trap

    __A=( "$@" "${__A[@]}" )
}

# array::random() {
#     (( $# == 1 || $# == 2 )) \
#     || raise "${E_PARAM_ERR}" 'incorrect invocation' \
#     || fatal

#     local -n __A=$1
#     local -n __acc=${2:-__}

#     check::vartype as __A \
#     || raise \
#     || return $?  # if no errcode trap

#     (( ${#__A[@]} != 0 )) \
#     || raise "${E_PARAM_ERR}" 'empty array' \
#     || return $?

#     local i=$(( RANDOM % ${#__A[@]} ))
#     printf -v __acc '%s\n' "${__A[i]}"
# }

array::reduce() {
    (( $# == 3 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1
    local -n __acc=${3:-__}
    local fun=$2

    check::vartype a __A \
    && check::vartype f fun \
    && check::vartype s __acc \
    || raise \
    || return $?  # if no errcode trap

    local x
    for x in "${__A[@]}"; do
        __acc=$( ${fun} "${__acc}" "${x}" ) \
        || raise 1 "failed \$fun ${x}" \
        || return $?
    done
}

# reverse array
# adapted from https://unix.stackexchange.com/a/412894
array::reverse() {
    (( $# == 1 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1

    check::vartype a __A \
    || raise \
    || return $?  # if no errcode trap

    reverse() {
        __A=( "${BASH_ARGV[@]:0:${BASH_ARGC[0]}}" )
    }

    shopt::push -s extdebug
    {  # active extdebug contex
        reverse "${__A[@]}" # steal reversion from bash
    }
    shopt::pop
}

array::rotate() {
    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1

    check::vartype a __A \
    || raise \
    || return $?  # if no errcode trap

    # reduce offset, we're done if it's 0
    local n=$(( $2 % ${#__A[@]} ))

    # assert array is not empty and offset is not 0 or we're done
    (( n && ${#__A[@]} != 0 )) \
    || return 0

    __A=( "${__A[@]: -${n}}" "${__A[@]:0: ( n >= 0 ) * ${#__A[@]} - ${n}}" )
}

# modern fisher-yates shuffle
array::shuffle() {
    (( $# == 1 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1

    check::vartype a __A \
    || raise \
    || return $?  # if no errcode trap

    swap() {
        local -n __x=$1
        local -n __y=$2
        local tmp=${__x}; __x=${__y}; __y=${tmp}
    }

    local i j
    for i in "${!__A[@]}"; do
        # shellcheck disable=SC2034  # j is used
        j=$(( i + RANDOM % ( ${#__A[@]} - i ) ))
        swap __A[j] __A[i]
    done
}

array::sort() {
    (( $# == 1 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1; shift

    check::cmd sort \
    && check::vartype a __A \
    || raise \
    || return $?  # if no errcode trap

    local IFS
    shopt::push -op noglob
    {  # no expansion contex
        # safe split and glob!
        local -a TMP
        readarray -t TMP < <( { IFS=$'\n'; sort <<< "${__A[*]}"; } );
        __A=("${TMP[@]}")
    }
    shopt::pop
}

array::split() {
    (( $# == 3 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1

    check::vartype a __A \
    || raise \
    || return $?  # if no errcode trap

    readarray -d $'\n' -t __A < <( printf '%s' "${2//$3/$'\n'}" )
}

array::uniq() {
    (( $# == 1 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __A=$1;

    check::vartype a __A \
    || raise \
    || return $?  # if no errcode trap

    local x
    local -A ITEMS
    for x in "${__A[@]}"; do
        IFS=' ' ITEMS+=( [${x}]=1 )
    done

    __A=( "${!ITEMS[@]}" )
}

array::zip() {
    (( $# == 3 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __D=$1
    local -n __K=$2
    local -n __V=$3

    check::vartype A __D \
    && check::vartype a __K \
    && check::vartype a __V \
    || raise \
    || return $?  # if no errcode trap

    # equalize array lengths
    if (( ${#__K[@]} < ${#__V[@]} )); then __V=( "${__V[@]:0:${#__K[@]}}" ); fi
    if (( ${#__V[@]} < ${#__K[@]} )); then __K=( "${__K[@]:0:${#__V[@]}}" ); fi

    local i
    __D=();
    for i in "${!__K[@]}"; do
        __D+=( [${__K[i]}]=${__V[i]} )
    done
}

array::init "$@"
