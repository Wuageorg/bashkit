# Changelog

## 1.2301.32

*Released Fri Jan 27 16:24:00 2023 +0100*

**Summary:**

The first public release of BashkitV1 is now [available](https://bashkit.wuage.org)
and from the main branch of the Bashkit [git repository](https://github.com/Wuageorg/bashkit).

Bashkit is the Wuage’s shell scripting modular framework.
It is a collection of pure bash functions along with a lightweight
scripting model that, we believe, remediate some of the
[Bash quirks](https://mywiki.wooledge.org/BashPitfalls) by enabling
simple yet sturdy *fail-fast* behaviours for scripts.

The framework is released under APACHE LICENSE, VERSION 2.0.
It complements at least bash 5.x and can not be used without.

The release tar file includes the formatted documentation (pdf).

Please report bugs with this version [here](https://github.com/Wuageorg/bashkit/issues).

**Features:**

Core modules (mandatory):

- revised control flows
- ANSI color for the masses
- error code handling
- exhaustive error scheme
- advanced logging routines
- thorough signal trap handling
- stateful bashkit versionning

Standard modules (on-demand):

- easy array manipulations
- advanced checking, including variable type checking
- curl download integration
- yes/no interaction support
- json conversions
- patch integration
- file permissions conversion
- readlink as a function
- shopt stacking
- semver comparison
- string manipulations
