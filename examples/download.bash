#!/usr/bin/env bash
# download.bash --
# bashkit example
# use gnu parallel to download files
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed

# shellcheck source=/dev/null  # bashkit is in path


source ../bashkit.bash curl

check::cmd parallel \
|| fatal

fetch_one() {
    curl -o "$1" "$2"
}
export -f fetch_one
cleanup 'export -nf fetch_one'

download() {
    local -n _URLS=$1

    check::vartype A _URLS \
    || raise \
    || error

    local -a JOBLOGS

    # readarray -t JOBLOGS < <(
    #     parallel -j0 --link --joblog - fetch_one ::: "${!__URLS[@]}" ::: "${__URLS[@]}"
    # )

    local file
    readarray -t JOBLOGS < <(
        for file in "${!_URLS[@]}"; do
            printf '%s\t%s\n' "${file}" "${_URLS[${file}]}"
        done | parallel -j0 --joblog - --colsep '\t' fetch_one
    )
    printf '%s\n' "${JOBLOGS[@]}"
}

main() {
    local src=http://212.183.159.230/5MB.zip
    local -A FILES

    local f
    for f in /tmp/{a..f}_orphan_5MB.zip; do
        FILES+=( [${f}]=${src} )
        cleanup "rm -f ${f}"
    done

    download FILES \
    || fatal 'download failed'
}

main
