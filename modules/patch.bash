#!/usr/bin/env bash
# patch.bash --
# bashkit module
# patch integration
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash patch\n'
    exit 1
fi

patch::init() {
    bashkit::load check
    debug done!
}

patch::apply() {
    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    check::cmd patch \
    || raise \
    || return $?


    local target=$1
    [[ -f ${target} || -d ${target} ]] \
    || raise "${E_ASSERT_FAILED}" "file not found: ${target}" \
    || return $?

    local patchset=$2
    [[ -f ${patchset} ]] \
    || raise "${E_ASSERT_FAILED}" "file not found: ${patchset}" \
    || return $?

    __=$(patch --binary -d "${target}" -p0 < "${patchset}" 2>&1) \
    || return $?

    __="applied ${patchset} to ${target}"
}

patch::batch() {
    (( $# == 2 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    check::cmd find patch sort \
    || raise "${__}" \
    || return $?

    local target=$1
    [[ -f ${target} || -d ${target} ]] \
    || raise "${E_ASSERT_FAILED}" "file not found: ${target}" \
    || return $?

    local patchdir=$2
    [[ -d ${patchdir} ]] \
    || raise "${E_ASSERT_FAILED}" "dir not found: ${patchdir}" \
    || return $?

    while read -d $'\0' -r patchset; do
        patch::apply "${target}" "${patchset}" || return $?
    done < <( find "${patchdir}" -type f -name '*.patch' -print0 | sort -z )

    __="applied ${patchdir} patches to ${target}"
}
