#!/usr/bin/env bash
# check.bash --
# bashkit module
# curl integration
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash curl\n'
    exit 1
fi

curl::init() {
    bashkit::load check string
    check::cmd curl \
    || fatal

    debug done!
}

# wrap curl with bashkit defaults
curl() {
    command curl \
        --connect-timeout 5 \
        --continue-at - \
        --fail \
        --location \
        --retry 5 \
        --retry-delay 0 \
        --retry-max-time 40 \
        --show-error \
        --silent \
        "$@"
}
export -f curl

# download and print stats
curl::download() {
    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    debug "downloading $1"

    __=$( curl "$1" -o "$2" 2>&1 ) \
    || raise \
    || return $?

    if [[ -f "$2" ]]; then
        check::cmd md5sum wc \
        || raise \
        || return "${E_PARTIAL}"  # no metadata but there's a downloaded file

        # adhoc extract size from wc output
        # read wc output and extract size using regex
        local size
        read -r size < <( wc -c "$2" )
        read -r size < <(
            string::regex "${size}" '^[[:space:]]*([0-9]+)[[:space:]]+'
        )

        # adhoc extract hash from md5sum output
        # read iteratively md5sum --tag output, the last one is the one
        local hash
        while read -d ' ' -r hash; do :; done < <( md5sum --tag -b "$2" )

        printf -v __ '%s %s %s' "$2" "${size}" "${hash}"
        debug "downloaded ${__}"

        return 0  # success
    fi
    return 1  # unspecified error condition
}

curl::init "$@"
