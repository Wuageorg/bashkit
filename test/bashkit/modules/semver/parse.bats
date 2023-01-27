#	"bats" test script for semver 2.0.0 specification (https://semver.org/)

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source semver.bash

NO_SEMVER="does not match semver"

@test "fails on incorrect invocation" {
    run -9 semver::parse
    run -9 semver::parse 1.2.2 1.0.0
}

@test "succeeds on correct invocation" {
    local _rc=0
    semver::parse 1.2.2 || _rc=$?
    (( _rc == 0 ))
}

@test "fails on invalid semver (major only)" {
    local _rc=0
    semver::parse 1 || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${NO_SEMVER}" ]]
}

@test "fails on invalid semver (minor only)" {
    local _rc=0
    semver::parse 1.1 || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${NO_SEMVER}" ]]
}

@test "fails on invalid semver (pre-release)" {
    local _rc=0
    semver::parse 1.1.1- || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${NO_SEMVER}" ]]
}

@test "fails on invalid semver (build)" {
    local _rc=0
    semver::parse 1.1.1+ || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${NO_SEMVER}" ]]
}

@test "succeeds on valid semver (build)" {
    local _rc=0
    semver::parse 1.2.3+5 || _rc=$?
    (( _rc == 0 ))
    (( __[0] == 1 ))
    (( __[1] == 2 ))
    (( __[2] == 3 ))
    (( __[3] == 0 ))
    (( __[4] == 5 ))
}

@test "succeeds on valid semver (major/minor/patch)" {
    local _rc=0
    semver::parse 1.2.3 || _rc=$?
    (( _rc == 0 ))
    (( __[0] == 1 ))
    (( __[1] == 2 ))
    (( __[2] == 3 ))
    (( __[3] == 0 ))
    (( __[4] == 0 ))
}

@test "succeeds on valid semver (pre-release)" {
    local _rc=0
    semver::parse 1.2.3-4 || _rc=$?
    (( _rc == 0 ))
    (( __[0] == 1 ))
    (( __[1] == 2 ))
    (( __[2] == 3 ))
    (( __[3] == 4 ))
    (( __[4] == 0 ))
}

@test "succeeds on valid semver (pre-release and build)" {
    local _rc=0
    semver::parse 1.2.3-4+5 || _rc=$?
    (( _rc == 0 ))
    (( __[0] == 1 ))
    (( __[1] == 2 ))
    (( __[2] == 3 ))
    (( __[3] == 4 ))
    (( __[4] == 5 ))
}
