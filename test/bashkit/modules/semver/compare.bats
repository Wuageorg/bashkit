#	"bats" test script for semver 2.0.0 specification (https://semver.org/)
#

# shellcheck disable=SC2016  # allow expression in single quotes
# shellcheck source=/dev/null

load "${BATS_TEST_DIRNAME%test*}/test/helper/common-setup"

bashkit_mock

source semver.bash

@test "compares released versions (lesser)" {
    local _rc=0
    semver::compare 0.2.1 0.2.2 || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "compares released versions (equal)" {
    local _rc=0
    semver::compare 1.2.1 1.2.1 || _rc=$?
    (( _rc == 0 ))
    (( __ == 0 ))
}

@test "compares released versions (greater)" {
    local _rc=0
    semver::compare 0.3.1 0.2.5 || _rc=$?
    (( _rc == 0 ))
    (( __ == 1 ))
}

@test "fails on bad version comparison" {
    local _rc=0
    semver::compare 1.1.1-rc1+build2 1.1.1-rc1+ || _rc=$?
    (( _rc == 1 ))
}

#	Precedence refers to how versions are compared to each other when ordered.
#	Precedence MUST be calculated by separating the version into major, minor,
#	patch and pre-release identifiers in that order (Build metadata does not figure
#	into precedence). Precedence is determined by the first difference when comparing
#	each of these identifiers from left to right as follows: Major, minor, and patch
#	versions are always compared numerically. Example: 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1.
#	When major, minor, and patch are equal, a pre-release version has lower precedence
#	than a normal version. Example: 1.0.0-alpha < 1.0.0. Precedence for two pre-release
#	versions with the same major, minor, and patch version MUST be determined by
#	comparing each dot separated identifier from left to right until a difference is
#	found as follows: identifiers consisting of only digits are compared numerically
#	and identifiers with letters or hyphens are compared lexically in ASCII sort order.
#	Numeric identifiers always have lower precedence than non-numeric identifiers.
#	A larger set of pre-release fields has a higher precedence than a smaller set,
#	if all of the preceding identifiers are equal. Example: 1.0.0-alpha < 1.0.0-alpha.1
#	< 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0.

@test "compares versions #1" {
    local _rc=0
    semver::compare 1.0.0-alpha 1.0.0-alpha.1 || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "compares versions #2" {
    local _rc=0
    semver::compare 1.0.0-alpha.1 1.0.0-alpha.beta || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "compares versions #3" {
    local _rc=0
    semver::compare 1.0.0-alpha.beta 1.0.0-beta || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "compares versions #4" {
    local _rc=0
    semver::compare 1.0.0-beta 1.0.0-beta.2 || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "compares versions #5" {
    local _rc=0
    semver::compare 1.0.0-beta.2 1.0.0-beta.11 || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "compares versions #6" {
    local _rc=0
    semver::compare 1.0.0-beta.11 1.0.0-rc.1 || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "compares versions #7" {
    local _rc=0
    semver::compare 1.0.0-rc.1 1.0.0 || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "compares versions (greater)" {
    local _rc=0
    semver::compare 1.0.0 1.0.0-rc.1 || _rc=$?
    (( _rc == 0 ))
    (( __ == 1 ))
}

@test "compares versions (alpha vs numeric)" {
    local _rc=0
    semver::compare 1.0.0-alpha 1.0.0-666 || _rc=$?
    (( _rc == 0 ))
    (( __ == 1 ))
}

@test "compares versions (equal)" {
    local _rc=0
    semver::compare 1.0.0 1.0.0 || _rc=$?
    (( _rc == 0 ))
    (( __ == 0 ))
}

@test "ignores pre-release when comparing" {
    local _rc=0
    semver::compare 1.0.1 1.0.0-rc1 || _rc=$?
    (( _rc == 0 ))
    (( __ == 1 ))
}

@test "compares pre-release (alpha)" {
    local _rc=0
    semver::compare 1.0.0-beta2 1.0.0-beta11 || _rc=$?
    (( _rc == 0 ))
    (( __ == 1 ))
}

@test "compares pre-release (numeric)" {
    local _rc=0
    semver::compare 1.0.0-2 1.0.0-11 || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "ignores build metadata (lesser)" {
    local _rc=0
    semver::compare 1.0.0-beta1+a 1.0.0-beta2+z || _rc=$?
    (( _rc == 0 ))
    (( __ == -1 ))
}

@test "ignores build metadata (equal)" {
    local _rc=0
    semver::compare 1.0.0-beta2+x 1.0.0-beta2+y || _rc=$?
    (( _rc == 0 ))
    (( __ == 0 ))
}

@test "ignores build metadata (greater)" {
    local _rc=0
    semver::compare 1.0.0-12.beta2+x 1.0.0-11.beta2+y || _rc=$?
    (( _rc == 0 ))
    (( __ == 1 ))
}

@test "ignores build metadata (equal/no pre-release)" {
    local _rc=0
    semver::compare 1.0.0+x 1.0.0+y || _rc=$?
    (( _rc == 0 ))
    (( __ == 0 ))
}
