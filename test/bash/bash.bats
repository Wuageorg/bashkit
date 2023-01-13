#!/usr/bin/env bats
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2016  # allow expression in single quotes

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"


@test "set +e should keep going on command error" {
    is_bashand && skip 'bashand';

    run -6 bash -c \
        '
        set +e # Useless/Confusing flag
        trap -- DEBUG # Disable bubbler
        echo "Success"
        false
        echo "Failed"
        exit 6
    '
    assert_output -p 'Success'
    assert_output -p 'Failed'

    run -6 bash -c \
        '
        set +e # Useless/Confusing flag
        trap -- DEBUG # Disable bubbler
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        f
        '
    assert_output -p 'Success'
    assert_output -p 'Failed'
}

@test "set -e; set -o errtrace should be useless with operator and functions" {
    is_bashand && skip 'bashand';

    run -1 bash -c \
        '
        set -e; set -o errtrace
        trap -- DEBUG # Disable bubbler
        echo "Success"
        false
        echo "Failed"
        exit 6
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    run -1 bash -c \
        '
        set -e; set -o errtrace
        trap -- DEBUG # Disable bubbler
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        f
        '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    run -1 bash -c \
        '
        set -e; set -o errtrace
        trap -- DEBUG # Disable bubbler
        g() { echo "Ok1"; }
        f() {
            echo "Success"
            g
            false
            echo "Failed"
            return 6
        }
        f
        '
    assert_output -p 'Success'
    assert_output -p 'Ok1'
    refute_output -p 'Failed'

    run -6 bash -c \
        '
        set -e; set -o errtrace
        trap -- DEBUG # Disable bubbler
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        f || exit "$?"
        '
    assert_output -p 'Success'
    assert_output -p 'Failed'

    run -8 bash -c \
        '
        set -e; set -o errtrace
        trap -- DEBUG # Disable bubbler
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        if f; then exit "7"; fi
        exit 8
        '
    assert_output -p 'Success'
    assert_output -p 'Failed'

    run -7 bash -c \
        '
        set -e; set -o errtrace
        trap -- DEBUG # Disable bubbler
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        if ! f; then exit "7"; fi
        exit 8
        '
    assert_output -p 'Success'
    assert_output -p 'Failed'
}

@test "return from block and func should behave differently" {
    run -0 bash -c \
        '
        deep() { return 3; }
        f1() { deep || return 4; }
        f2() { { return 2; } || return 5; }
        f1
        echo "$?"
        f2
        echo "$?"
    '
    assert_output -p '4'
    assert_output -p '2'
}

@test "! looses return code" {
    run -0 bash -c \
    '
        f() {
            echo "Success"
            return 5
            echo "Failed"
            return 6
        }
        if ! f; then exit "$?"; fi
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'
}

@test "for loop variable are not local" {
    # This doesn't work at all
    run -0 bash -c \
    '
        foo() {
            for i in 4 5 6; do
                true
            done
        }

        for i in 0 1 2; do
            foo
        done
        echo "$i"
    '
    assert_output '6'
}

@test "for loop variable can be local" {
    # This doesn't work at all
    run -0 bash -c \
    '
        foo() {
            local i
            for i in 4 5 6; do
                true
            done
        }

        for i in 0 1 2; do
            foo
        done
        echo "$i"
    '
    assert_output '2'
}

DEBUG_TRAP_FULL='{
  __rc=${?}

  pass="(break|catch|continue|error|fatal|panic|return|exit|true)"
  if (( ${__rc} > 0 )) && ! [[ ${BASH_COMMAND%% *} =~ ${pass} ]]; then
        if [[ -n ${FUNCNAME+_} ]]; then return ${__rc}; else exit ${__rc}; fi
  fi
}'

DEBUG_TRAP_MINI='{
  __rc=${?}

  if (( ${__rc} > 0 )); then
        if [[ -n ${FUNCNAME+_} ]]; then return ${__rc}; else exit ${__rc}; fi
  fi
}'

@test "bubbler mini should always bubble errors" {
    run -1 bash -c \
    "trap '${DEBUG_TRAP_MINI}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        f
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    # Here we would prefer to exit 4 but
    # DEBUG_TRAP_MINI isn't smart enough
    # || operator become a no-op
    run -1 bash -c \
    "trap '${DEBUG_TRAP_MINI}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        f || exit 4
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    # Luckily ! if/while/for/...
    # still works correctly
    run -9 bash -c \
    "trap '${DEBUG_TRAP_MINI}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        if ! f; then exit 9; fi
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    # And works for variable in a [[ context
    run -3 bash -c \
    "trap '${DEBUG_TRAP_MINI}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        a="AAA"
        b="B"
        if [[ "${a}" = "B" || "${b}" = "B" ]]; then exit 3; fi
    '

    # And works for variable in a (( context
    run -2 bash -c \
    "trap '${DEBUG_TRAP_MINI}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        a=0
        b=4
        if (( a > 1 || b != 5 )); then exit 2; fi
    '
}

@test "bubbler full should bubble errors except for well know functions" {
    run -1 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        f
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    # exit
    run -4 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        f || exit 4
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    # true
    run -0 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        f || true
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    # return
    run -3 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        g() { f || return 3; }
        g
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    # catch
    run -0 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;

        catch() {
            true; # User provided func need to start with true;
            "$@"
        }

        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        g() { f || catch echo "catched"; }
        g
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'
    assert_output -p 'catched'

    # catchpow2 this a trap
    # sadly this doesn't work as bash evaluate subshell first
    # workaround below
    run -0 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        catch() {
            true; # User provided func need to start with true;
            "$@"
        }

        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        g() { f || catch echo A $(printf "%s" catched); }
        g
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'
    assert_output -p 'A'

    # catchpow3 use true trick
    run -0 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        catch() {
            true; # User provided func need to start with true;
            "$@"
        }

        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        g() { f || catch echo A $(true; printf "%s" catched); }
        g
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'
    assert_output -p 'A catched'

    run -9 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        if ! f; then exit 9; fi
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'

    # Also else doesn't work anymore
    # this should print inelse but doesn't
    # and it return 5 instead of 0
    run -5 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            return 5
            echo "Failed"
            return 6
        }
        if f; then true; else echo inelse; fi
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'
    refute_output -p 'inelse'

    # Here the true trick again
    run -0 bash -c \
    "trap '${DEBUG_TRAP_FULL}' DEBUG;"'
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            return 5
            echo "Failed"
            return 6
        }
        if f; then true; else true; echo inelse; fi
    '
    assert_output -p 'Success'
    refute_output -p 'Failed'
    assert_output -p 'inelse'
}


@test "bubbler mini func should always bubble errors but doesn't because it's a func" {
    is_bashand && skip 'bashand';

    # This doesn't work at all
    run -6 bash -c \
    "bubbler() ${DEBUG_TRAP_MINI}"'
        trap bubbler DEBUG
        set +e; shopt -u extdebug; set -o functrace;
        f() {
            echo "Success"
            false
            echo "Failed"
            return 6
        }
        f
    '
    assert_output -p 'Success'
    assert_output -p 'Failed'
}
