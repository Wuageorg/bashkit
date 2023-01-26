#	"bats" test script for semver 2.0.0 specification (https://semver.org/)

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source semver.bash

PARSE_ERR_MSG_REX="does not match semver"

@test "incorrect number of args in semver::parse" {
    run -9 semver::parse
    run -9 semver::parse 1.2.2 1.0.0
}

@test "correct arg in semver::parse" {
    local _rc=0
    semver::parse 1.2.2 || _rc=$?
    (( _rc == 0 ))
}

@test "invalid semver with major only" {
    local _rc=0
    semver::parse 1 || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "invalid semver with minor only" {
    local _rc=0
    semver::parse 1.1 || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "valid semver with major/minor/patch" {
    local _rc=0
    semver::parse 1.2.3 || _rc=$?
    (( _rc == 0 ))
    (( __[0] == 1 ))
    (( __[1] == 2 ))
    (( __[2] == 3 ))
    (( __[3] == 0 ))
    (( __[4] == 0 ))
}

@test "invalid semver with pre-release" {
    local _rc=0
    semver::parse 1.1.1- || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "valid semver with pre-release" {
    local _rc=0
    semver::parse 1.2.3-4 || _rc=$?
    (( _rc == 0 ))
    (( __[0] == 1 ))
    (( __[1] == 2 ))
    (( __[2] == 3 ))
    (( __[3] == 4 ))
    (( __[4] == 0 ))
}

@test "invalid semver with build" {
    local _rc=0
    semver::parse 1.1.1+ || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "valid semver with build" {
    local _rc=0
    semver::parse 1.2.3+5 || _rc=$?
    (( _rc == 0 ))
    (( __[0] == 1 ))
    (( __[1] == 2 ))
    (( __[2] == 3 ))
    (( __[3] == 0 ))
    (( __[4] == 5 ))
}

@test "valid semver with pre-release and build" {
    local _rc=0
    semver::parse 1.2.3-4+5 || _rc=$?
    (( _rc == 0 ))
    (( __[0] == 1 ))
    (( __[1] == 2 ))
    (( __[2] == 3 ))
    (( __[3] == 4 ))
    (( __[4] == 5 ))
}
