#!/usr/bin/env bash
# log.bash --
# bashkit example
# generate all kinds of logging lines
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck source=/dev/null  # bashkit is in path

source ../bashkit.bash

LOREM=\
"Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore
magna aliqua. Ut enim ad minim veniam, quis nostrud
exercitation ullamco laboris nisi ut aliquip ex ea
commodo consequat. Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat
non proident, sunt in culpa qui officia deserunt mollit
anim id est laborum."

declare -a LOREM_WORDS
state=OUT
for (( i=0; i < ${#LOREM}; i++ )); do
    case ${state} in
        OUT)
            if ! [[ ${LOREM:i:1} =~ [[:space:]] ]]; then
                    LOREM_WORDS+=( "${i}" )
                    state=IN
            fi;;
        IN)
            if [[ ${LOREM:i:1} =~ [[:space:]] ]]; then
                state=OUT
            fi;;
    esac
done

# return a lorem ipsum sample
lorand() {
    # between min and max consecutive words
    local min=$1 max=$2

    local i len start end
    len=$(( min + RANDOM % (max - min) ))
    i=$(( RANDOM % (${#LOREM_WORDS[@]} - len) ))

    start=${LOREM_WORDS[i]}
    end=$(( ${LOREM_WORDS[i+len]}-start-1 ))

    printf '%s' "${LOREM:start:end}"
}

main() {
    local fun
    local -a FUNS=( ut enim ad minim veniam quis nostrud exercitation )
    for fun in "${FUNS[@]}"; do
        eval "${fun}()" '{
            local msg=$1

            case $(( 1 + RANDOM % 6 )) in
                1) alert "${msg}";;
                2) crit  "${msg}";;
                3) error "${msg}";;
                4) warn  "${msg}";;
                5) note  "${msg}";;
                6) info  "${msg}";;
                *) fatal '\''bad command'\'';;
            esac
        }'
    done

    local nlog=${1:-10} msg
    while (( nlog-- )); do
        fun=${FUNS[RANDOM % ${#FUNS[@]}]}
        msg=$( lorand 4 12 )  # betwwen 4 and 12 lorem ipsum words
        msg=${msg//$'\n'/ }   # single line, comment for multiline

        ${fun} "${msg}"
    done
}

main "$@"
