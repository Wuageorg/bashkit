#!/usr/bin/env bash
# leb128.bash --
# Little Endian Base 128 encoder/decoder
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck source=/dev/null  # bashkit is in path

source ../../bashkit.bash array check extras

leb128::encode() {
    local -i s32=$(( $1 | 0 ))
    # shellcheck disable=SC2034  # LEB is used
    local -n _LEB128=${2:-__}

    check::vartype a _LEB128 \
    || raise

    local b
    for((
        b=s32 & 0x7f, s32>>=7;
        (s32 && !(b & 0x40)) || (s32 != -1 && (b & 0x40));
        b=s32 & 0x7f, s32>>=7
    )); do
        array::push _LEB128 $(( b | 0x80 ))
    done
    array::push _LEB128 "${b}"
}

leb128::decode() {
    # shellcheck disable=SC2034  # LEB is used
    local -n _LEB128=$1
    local -n _s32=${2:-__}

    check::vartype a _LEB128 \
    || raise

    local b off=0
    _s32=0
    for b in "${_LEB128[@]}"; do
        _s32=$(( _s32 | (b & 0x7f) << off ))
        off=$(( off + 7 ))
    done

    (( (b & 0x40) == 0 )) \
    || resume let _s32=$(( _s32 | (~0 << off) ))

    return
}

leb128::str() {
    local -n _LEB128=${1:-__}

    check::vartype a _LEB128 \
    || raise

    printf '( '
    local i
    for (( i=0; i<${#_LEB128[@]}; i++ )); do
        printf '%02x ' "${_LEB128[i]}"
    done
    printf ')'
}

main() {
    local n=${1:- -123456}

    isint "${n}" \
    || fatal

    local -i s32

    # shellcheck disable=SC2034  # LEB is used
    local -a L128

    leb128::encode n L128
    printf '%d -> %s\n' "${n}" "$(leb128::str L128)"

    leb128::decode L128 s32
    printf '%s -> %d\n' "$(leb128::str L128)" ${s32}

    (( s32 == n ))
}

if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    main "$@"
fi
