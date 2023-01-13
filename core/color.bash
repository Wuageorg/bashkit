#!/usr/bin/env bash
# color.bash --
# bash module part of bashkit
# ansi color routines
# this module may be used without bashkit
# ----
# (ɔ) 2022 wuage.org

# shellcheck source-path=SCRIPTDIR
# shellcheck enable=require-variable-braces,check-set-e-suppressed


if [[ $0 = "${BASH_SOURCE[0]}" ]]; then
    printf '%s is to be sourced not executed!\n' "${BASH_SOURCE[0]}"
    exit 1
fi

color::init() {
    # assert not already initialized or return
    if declare -p __ANSI_COLORS &> /dev/null; then
        return 0  # already initialized
    fi

    # https://en.wikipedia.org/wiki/ANSI_escape_code
    declare -g -A __ANSI_COLORS=(
        [black]=0  [red]=1   [green]=2
        [yellow]=3 [blue]=4  [magenta]=5
        [cyan]=6   [white]=7 [default]=9

        [foreground]=30 [background]=40

        [bright]=60

        [regular]=0  [bold]=1       [dim]=2
        [italic]=3   [underlined]=4 [blinking]=5
        [reversed]=7 [hidden]=8     [strikethrough]=9
    )

    local fun
    # declare errcode replacements when not used with bashkit
    # shellcheck disable=SC2016  # we don't want to expand now
    local -A BASICS=(
        [catch]='{ ____=$?; local -n __rc=${1:-____}; __rc=${____}; }'
        [cleanup]='{ trap "$@" EXIT; }'
        [fatal]='{ exit $?; }'
        [raise]='{ rc=${1:-1}; shift; __=$*; return "${rc}"; }'
        [resume]='{ catch; "$@"; }'
    )
    for fun in "${!BASICS[@]}"; do
        declare -f "${fun}" &> /dev/null \
        || eval "${fun}() ${BASICS[${fun}]}"
    done

    E_PARAM_ERR=${E_PARAM_ERR:-9}

    cleanup 'unset __ANSI_COLORS;'
} 2> /dev/null  # suppress trace output

color::encode() {
    # input examples:
    #   bold blinking red text black background
    #   reset
    #   regular green text yellow background
    #   green text white background
    #   bold black text bright white background
    local -a DESC=( "$@" )

    if [[ ${DESC[0]:-} = reset || ${#DESC[@]} = 0 ]]; then
        __=\\x1b[0m
        return 0
    fi

    # an ansi code consists of a prefix ('\\x1b['), two sections (describing
    # foreground and background colors) separated by a semicolon, and a suf-
    # fix (']m'):
    #   \\x1b[<foreground>;<background>]m
    # foreground and background have the same layout:
    #   <section>=a1;...;an;color where
    # a1...an are optional attributes to the font or its context (bold,
    # bright, reversed...)

    # {fore,back}ground[maxcolor] is a sentinel. It's a static value computed
    # after ansi specs such as:
    #    {fore/back}ground[curcolor] <= {fore/back}ground[maxcolor]
    # must be true
    # {fore/back}ground[curcolor] is the current color value, at first:
    #   - foreground maxcolor is  97 curcolor is foreground default 39
    #   - background maxcolor is 107 curcolor is background default 49
    local -r maxcolor=0 curcolor=1
    local -a FOREGROUND=(
        [maxcolor]=97
        [curcolor]=$(( __ANSI_COLORS[foreground] + __ANSI_COLORS[default] ))
    )
    local -a BACKGROUND=(
        [maxcolor]=107
        [curcolor]=$(( __ANSI_COLORS[background] + __ANSI_COLORS[default] ))
    )

    # parse/tokenize input then encode/output color code using a state machine:
    #   - $__sect points toward an array which stores {fore,back}ground tokens
    #     as they are parsed
    #   - $__sect pointee is named after states {FORE,BACK}GROUND
    #   - any mismatch is fatal
    #   - | A | reads: in state A,
    #   - | A | cond | B | reads: on cond, transition from state A to state B
    #   - |   A   | reads: while in state A parse next token
    #      \token/
    #   -  => reads transition unconditionally
    #
    #   the encoding machine does:
    #
    #   |FOREGROUND| token='text' |BACKGROUND| token=EOF |encode| => |output|
    #     \token/                   \token/

    # parsed attributes
    local -A ATTRS

    encode__getattr() {
        [[ -v ATTRS[$1] ]]
    }

    # set only once
    encode__setattr() {
        if [[ -v ATTRS[$1] ]]; then
            return 1 # fail if already set
        fi

        ATTRS+=( [$1]=1 ) # otherwise set!
    }

    local i token
    local -n __sect=FOREGROUND
    for i in "${!DESC[@]}"; do
        token=${DESC[i],,}  # lowercase
        case ${token} in
            bright)
                # assert one bright attribute *before* color
                encode__setattr bright && ! encode__getattr color \
                || raise "${E_PARAM_ERR}" 'bad color: misplaced bright' \
                || return $?
                ;;
            black|blue|cyan|green|magenta|red|white|yellow)
                # compute color value
                (( __sect[curcolor]+=\
                    __ANSI_COLORS[${token}] - __ANSI_COLORS[default] ))
                # update for brightness
                ! encode__getattr bright \
                || (( __sect[curcolor]+=__ANSI_COLORS[bright] ))

                ;&  # fallthrough!
            default)
                # assert a single in range color per $__sect
                encode__setattr color \
                && (( __sect[curcolor] <= __sect[maxcolor] )) \
                || raise "${E_PARAM_ERR}" 'bad color: out of range' \
                || return $?
                ;;
            blinking|bold|dim|italic|hidden|regular|reversed\
            |strikethrough|underlined)
                # assert non repeating attribute
                encode__setattr "${token}" \
                || raise "${E_PARAM_ERR}" 'bad color: repeating attribute' \
                || return $?

                __sect+=( "${__ANSI_COLORS[${token}]}" )
                ;;
            text)
                # assert first text token
                encode__setattr text \
                || raise "${E_PARAM_ERR}" 'bad color: misplaced text' \
                || return $?

                # switch state from foreground to background:
                # once 'text' is read the remaining describes background
                # shellcheck disable=SC2178  # shellcheck gets confused by refs
                local -n __sect=BACKGROUND
                ATTRS=( [text]=1 ) # reset for background parsing
                ;;
            background)
                # assert 'background' is the description last word
                (( i == ${#DESC[@]} - 1 )) \
                || raise "${E_PARAM_ERR}" 'bad color: misplaced background' \
                || return $?
                ;;
            *)
                raise "${E_PARAM_ERR}" 'bad color: invalid token' \
                || return $?
                ;;
        esac
    done

    # ANSI encode from sections
    local code

    # slice maxcolor out
    FOREGROUND=( "${FOREGROUND[@]:1}" )
    BACKGROUND=( "${BACKGROUND[@]:1}" )

    # rotate array left if -n, right if +n
    encode__rotate() {
        local -n __A=$1; shift;
        __A=( "${__A[@]: -$1}" "${__A[@]:0: -$1}" )
    }

    # bring attributes to the front of section and put color values last:
    encode__rotate FOREGROUND -1; # rotate left once
    encode__rotate BACKGROUND -1;

    # join array into string using $1 separator
    encode__join() {
        local IFS=$1; __=${*:2}
    }

    # concat code
    # {f,b}1,...{f,b}n are attributes {fore,back}color is the color value:

    # partial: '\\x1b[f1;...;fn;forecolor' + ';'
    encode__join \; "${FOREGROUND[@]}"; code=\\x1b[${__}\;

    # complete:'\\x1b[f1;...;fn;forecolor;b1;...;bm;backcolor' + 'm'
    encode__join \; "${BACKGROUND[@]}"; code+=${__}m

    # output
    printf -v __ '%s' "${code}"
} 2> /dev/null  # suppress trace output

color::is_enabled() {
    # we want colors, output is a tty and `$TERM` supports them
    ! [[ -v NO_COLOR ]] \
        && [[ -t 2 && ( ${TERM:-} =~ (xterm|screen).* ) ]]
}

color::table() {
    (( $# == 1 )) \
    || raise "${E_PARAM_ERR}" 'incorrect invocation' \
    || fatal

    local -n __LUT=$1  # color lookup table

    local k
    local -a DESC
    for k in "${!__LUT[@]}"; do
        readarray -d ' ' -t DESC < <( printf '%s' "${__LUT[${k}]}" )

        color::encode "${DESC[@]}" \
        || error "${__}" \
        || return $?  # if no errcode trap

        __LUT[${k}]=${__}
    done
}

color::init "$@"
