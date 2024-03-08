#!/usr/bin/env bash
# bashbinpatch.bash --
# bashkit module
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

if ! declare -p BASHKIT &> /dev/null; then
    printf 'try source bashkit.bash\n'
    exit 1
fi

bashbinpatch__is_and_and() {
    __connector_test() {
        false
        true
    }
    if __connector_test; then
        unset -f __connector_test
        return 1
    fi
    unset -f __connector_test
    return 0
}

bashbinpatch::handler() {
    cmd=${1:-status}

    case ${cmd} in
        enable)
            # command connector is already and_and
            if bashbinpatch__is_and_and; then
                return 0
            fi
            warn '/!\ binpatching is dirty, and might not work with all bash versions'
            shift
            bashbinpatch__patch "$@"
            ;;
        disable)
            warn '!!! disabling bashbinpatch handler is not advised !!!'
            debug 'disabling bashbinpatch handler may result in non obvious bad script side effects'
            if bashbinpatch__is_and_and; then
                error "cannot disable bashbinpatch, it is builtin into bash binary (${BASH})"
                return 1
            fi
            ;;
        status)
            if bashbinpatch__is_and_and; then
                return 0
            fi
            return 1
            ;;
        *)
            fatal 'bad command'
            ;;
    esac
}

bashbinpatch__patch() {
    local dir="${BASHBINPATCH_DIR:-${XDG_RUNTIME_DIR:-${TMPDIR:-${HOME:-.}}}}/.bashbinpatch"
    local bashand="${dir}/bash"

    if (("${BASH_VERSINFO[0]}" < 5 )) \
    && { (("${BASH_VERSINFO[0]}" < 4 )) && (("${BASH_VERSINFO[1]}" < 1 )); }; then
        raise "Minimum supported bash version is 4.1" \
        || fatal
    fi
    if (("${BASH_VERSINFO[0]}" > 4 )) && (("${BASH_VERSINFO[1]}" > 2 )); then
        raise "Maximum supported bash version is 5.2" \
        || fatal
    fi

    if [[ "${BASH_ARGV0##*/}" == "bash" ]]; then
        # ARGV0 is bash probably called with bash -c
        raise "bash -c, no dynamic bashand" || return ${?}
    fi

    bashkit::load check

    check::cmd xxd tr sed grep wc
    check::dir "${dir}"

    if ! [[ -f "${bashand}" ]]; then
        local pos=2 # Bash < 5.2
        if (("${BASH_VERSINFO[0]}" > 4 )) && (("${BASH_VERSINFO[1]}" > 1 )); then
            pos=3
        fi
        case "${HOSTTYPE}" in
            x86_64)
                local linecount
                read -r linecount < <( xxd -p -c 0 "${BASH}" | tr -d '[:space:]' | grep -o 'ba3b000000' | wc -l )
                case ${linecount} in
                    2|3) : ;;
                    *) raise "unexpected line count (${linecount})" || return $? ;;
                esac
                xxd -p -c 0 "${BASH}" \
                    | tr -d '[:space:]' \
                    | sed "s|ba3b000000|ba20010000|${pos}" \
                    | xxd -r -p > "${bashand}"
            ;;
            i386|i686)
                # i386 use a 2byte instruction to push ';'(0x3b)
                # making it hard to patch to '&&'(0x120)
                raise "${HOSTTYPE} unimplemented!" || return $?
            ;;
            aarch64)
                local linecount
                read -r linecount < <( xxd -p -c 0 "${BASH}" | tr -d '[:space:]' | grep -o '62078052' | wc -l )
                case ${linecount} in
                    1) pos=1 ;;
                    3) : ;;
                    *) raise "unexpected line count (${linecount})" || return $? ;;
                esac
                xxd -p -c 0 "${BASH}" \
                    | tr -d '[:space:]' \
                    | sed "s|62078052|02248052|${pos}" \
                    | xxd -r -p > "${bashand}"
            ;;
            arm*)
                local linecount
                read -r linecount < <( xxd -p -c 0 "${BASH}" | tr -d '[:space:]' | grep -o '3b20a0e3' | wc -l )
                case ${linecount} in
                    2) : ;;
                    *) raise "unexpected line count (${linecount})" || return $? ;;
                esac
                xxd -p -c 0 "${BASH}" \
                    | tr -d '[:space:]' \
                    | sed "s|3b20a0e3|122ea0e3|${pos}" \
                    | xxd -r -p > "${bashand}"
            ;;
            *) raise "${HOSTTYPE} unimplemented!" || return $? ;;
        esac
    fi
    # fix perms
    chmod 700 "${dir}"
    chmod 500 "${bashand}"
    export PATH="${dir}:${PATH}"
    exec "${bashand}" "${BASH_ARGV0}" "$@"
}
