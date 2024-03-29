#	"bats" test script for semver 2.0.0 specification (https://semver.org/)
#

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source semver.bash

PARSE_ERR_MSG_REX="does not match semver"

@test "gets major" {
    local _rc=0
    semver::parse 0.2.1-rc1.0+build-1234 || _rc=$?
    (( _rc == 0 ))
    (( __[0] == 0 ))
}

@test "gets minor" {
    local _rc=0
    semver::parse 0.2.1-rc1.0+build-1234 || _rc=$?
    (( _rc == 0 ))
    (( __[1] == 2 ))
}

@test "gets patch" {
    local _rc=0
    semver::parse 0.2.1-rc1.0+build-1234 || _rc=$?
    (( _rc == 0 ))
    (( __[2] == 1 ))
}

@test "gets prerelease" {
    local _rc=0
    semver::parse 0.2.1-rc1.-0+build-1234 || _rc=$?
    # echo "${__[@]}" > /dev/tty
    (( _rc == 0 ))
    [[ ${__[3]} = "rc1.-0" ]]
}

@test "gets build" {
    local _rc=0
    semver::parse 0.2.1-rc1.0+build-0234 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[4]} = "build-0234" ]]
}

@test "gets release" {
    local _rc=0
    semver::parse 0.2.1-rc1.0+build-1234 || _rc=$?
    (( _rc == 0 ))
    [[ "${__[0]}.${__[1]}.${__[2]}" = "0.2.1" ]]
}

@test "fails on bad minor" {
    local _rc=0
    semver::parse 1.2. || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on missing mandatory prerelease" {
    local _rc=0
    semver::parse 1.2.4- || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on missing mandatory build" {
    local _rc=0
    semver::parse 1.2.4+ || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

#	A build-metadata version MAY be denoted by appending a hyphen and a series of dot
#	separated identifiers immediately following the patch version. Identifiers MUST
#	comprise only ASCII alphanumerics and hyphen [0-9A-Za-z-]. Identifiers MUST NOT
#	be empty. Numeric identifiers MUST NOT include leading zeroes. Pre-release versions
#	have a lower precedence than the associated normal version. A pre-release version
#	indicates that the version is unstable and might not satisfy the intended
#	compatibility requirements as denoted by its associated normal version.
#	Examples: 1.0.0-alpha, 1.0.0-alpha.1, 1.0.0-0.3.7, 1.0.0-x.7.z.92.

@test "gets valid alpha" {
    local _rc=0
    semver::parse 1.0.0-alpha || _rc=$?
    (( _rc == 0 ))
    [[ ${__[3]} = "alpha" ]]
}

@test "gets valid pre-release (alpha & numeric)" {
    local _rc=0
    semver::parse 1.0.0-alpha.1 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[3]} = "alpha.1" ]]
}

@test "gets valid pre-release (alpha w/zero & numeric)" {
    local _rc=0
    semver::parse 1.0.0-0alpha.1 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[3]} = "0alpha.1" ]]
}

@test "gets valid pre-release (numeric)" {
    local _rc=0
    semver::parse 1.0.0-0.3.7 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[3]} = "0.3.7" ]]
}

@test "gets valid pre-release (complex w/alpha)" {
    local _rc=0
    semver::parse 1.0.0-x.7.z.92 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[3]} = "x.7.z.92" ]]
}

@test "get valid pre-release (w/hypen)" {
    local _rc=0
    semver::parse 1.0.0-x-.7.--z.92- || _rc=$?
    (( _rc == 0 ))
    [[ ${__[3]} = "x-.7.--z.92-" ]]
}

@test "fails on invalid pre-release ($)" {
    local _rc=0
    semver::parse "1.0.0-x.7.z$.92" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid in pre-release (_)" {
    local _rc=0
    semver::parse "1.0.0-x_.7.z.92" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid in pre-release (leading zero)" {
    local _rc=0
    semver::parse "1.0.0-x.7.z.092" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid pre-release (2 leading zeros)" {
    local _rc=0
    semver::parse "1.0.0-x.07.z.092" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid pre-release (embedded empty identifier)" {
    local _rc=0
    semver::parse "1.0.0-x.7.z..92" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid pre-release (leading empty identifier)" {
    local _rc=0
    semver::parse "1.0.0-.x.7.z.92" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid pre-release (trailing empty identifier)" {
    local _rc=0
    semver::parse "1.0.0-x.7.z.92." || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

#	Build metadata MAY be denoted by appending a plus sign and a series of dot
#	separated identifiers immediately following the patch or pre-release version.
#	Identifiers MUST comprise only ASCII alphanumerics and hyphen [0-9A-Za-z-].
#	Identifiers MUST NOT be empty. Build metadata MUST be ignored when determining
#	version precedence. Thus two versions that differ only in the build metadata,
#	have the same precedence. Examples: 1.0.0-alpha+001, 1.0.0+20130313144700,
#	1.0.0-beta+exp.sha.5114f85.

@test "gets valid build-metadata (numeric)" {
    local _rc=0
    semver::parse 1.0.0-alpha+001 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[4]} = "001" ]]
}

@test "gets valid build-metadata (numeric after patch)" {
    local _rc=0
    semver::parse 1.0.0+20130313144700 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[4]} = "20130313144700" ]]
}

@test "gets valid build-metadata (alpha & numeric)" {
    local _rc=0
    semver::parse 1.0.0-beta+exp.sha.5114f85 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[4]} = "exp.sha.5114f85" ]]
}

@test "gets valid build-metadata (alpha & numeric after patch)" {
    local _rc=0
    semver::parse 1.0.0+exp.sha.5114f85 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[4]} = "exp.sha.5114f85" ]]
}

@test "gets valid build-metadata (leading zero)" {
    local _rc=0
    semver::parse 1.0.0-x.7.z.92+02 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[4]} = "02" ]]
}

@test "gets valid build-metadata (leading hypen)" {
    local _rc=0
    semver::parse 1.0.0-x.7.z.92+-alpha-2 || _rc=$?
    (( _rc == 0 ))
    [[ ${__[4]} = "-alpha-2" ]]
}

@test "gets valid build-metadata (trailing hypen)" {
    local _rc=0
    semver::parse 1.0.0-x.7.z.92+-alpha-2- || _rc=$?
    (( _rc == 0 ))
    [[ ${__[4]} = "-alpha-2-" ]]
}

@test "fails on invalid build-metadata ($)" {
    local _rc=0
    semver::parse "1.0.0-x+7.z$.92" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid build-metadata (_)" {
    local _rc=0
    semver::parse "1.0.0-x+7.z.92._" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid build-metadata (character after patch)" {
    local _rc=0
    semver::parse "1.0.0+7.z$.92" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid build-metadata (embedded empty identifier)" {
    local _rc=0
    semver::parse "1.0.0-x+7.z..92" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid build-metadata (leading empty identifier)" {
    local _rc=0
    semver::parse "1.0.0+.x.7.z.92" || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}

@test "fails on invalid build-metadata (trailing empty identifier)" {
    local _rc=0
    semver::parse "1.0.0-x.7+z.92." || _rc=$?
    (( _rc == 1 ))
    [[ ${__} =~ "${PARSE_ERR_MSG_REX}" ]]
}
