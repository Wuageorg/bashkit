#!/usr/bin/env bash
# json.bash --
# bashkit module
# implements json utils
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed
# shellcheck disable=SC2178 # shellcheck gets confused by refnames


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash json\n'
    exit 1
fi

json::init() {
    bashkit::load check
    debug done!
}

json::from_toml() {
    json__pymod toml \
    || raise \
    || return $?

    python3 -c '
import sys, toml, json;
json.dump(
    toml.load(
        open(sys.argv[1])
    ),
    sys.stdout,
    indent=4,
    default=str
)' "$@"

}

json::from_yaml() {
    json__pymod yaml \
    || raise \
    || return $?

    python3 -c '
import sys, json, yaml;
json.dump(
    yaml.safe_load(
        open(sys.argv[1])
    ),
    sys.stdout,
    indent=4,
    default=str
)' "$@"
}

json::into_array() {
    check::cmd jq \
    || raise \
    || return $?

    unset "${1}"
    declare -g -a "$1"="(
        $(
            jq -r '@sh'
        )
    )"
}

json::into_dict() {
    check::cmd jq \
    || raise \
    || return $?

    unset "${1}"
    declare -g -A "$1"="(
        $(
            jq -r 'to_entries[] | @sh "[\(.key)]=\(.value | if type=="array" or type=="object" then @json else . end)"'
        )
    )"
}

json::to_toml() {
    json__pymod toml \
    || raise \
    || return $?

    python3 -c '
import sys, json, toml;
print(
    toml.dumps(
        json.load(
            open(sys.argv[1])
        )
    )
)' "$@"
}

json::to_yaml() {
    json__pymod yaml \
    || raise \
    || return $?

    python3 -c '
import sys, json, yaml;
print(
    yaml.dump(
        json.load(
            open(sys.argv[1])
        ),
        default_flow_style=False
    )
)' "$@"
}

json__pymod() {
    (( $# != 0 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    check::cmd python3 \
    || raise \
    || return $?

    local mod valid='[a-z_]+'
    for mod; do
        __='bad module name'
        if [[ ${mod} =~ ${valid} ]]; then
            # try import
            python3 -c "import ${mod}" < /dev/null 2> /dev/null \
            || raise "${E_PARAM_ERR}" "python3 module ${mod} not found" \
            || return $?

            continue  # success, loop mod!
        fi

        raise "${E_PARAM_ERR}" \
        || return $?
    done
}
