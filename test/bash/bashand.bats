#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "transform newlines to && but not line ending with ; in functions" {
    is_bashand || skip 'need bashand';
    { ! shopt default_connector_and_and &>/dev/null; } || skip 'need binpatch bashand';

    f() {
        a
        b
    }
    run -0 declare -fp f
    assert_output -p '&&'

    f() {
        a;
        b;
    }
    run -0 declare -fp f
    refute_output -p '&&'
}

@test "keeps line precedence" {
    is_bashand || skip 'need bashand';

    precedence1() {
        false
        true || return 6
    }

    precedence2() {
        false
        { true || return 6; }
    }

    precedence3() {
        false && \
        { true || return 6; }
    }

    precedence4() {
        false && \
        true || return 6
    }

    precedence1 || _rc=${?}
    assert_equal 1 ${_rc}

    precedence2 || _rc=${?}
    assert_equal 1 ${_rc}

    precedence3 || _rc=${?}
    assert_equal 1 ${_rc}

    precedence4 || _rc=${?}
    assert_equal 6 ${_rc}
}

@test "doesn't transform newlines at top level" {
    is_bashand || skip 'need bashand';

    run -0 bash -c \
        '
            shopt -s default_connector_and_and &>/dev/null || true;
            kludge
            true
        '
}

@test "does transform newlines at top level in a block" {
    is_bashand || skip 'need bashand';

    run -127 bash -c \
        '
            shopt -s default_connector_and_and &>/dev/null || true;
            {
                kludge
                true
            }
        '
}
