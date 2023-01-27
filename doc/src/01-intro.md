# What is bashkit
Bashkit is an opiniated scripting model and framework for [Bash 5.x](https://www.gnu.org/software/bash/).
It is intended to help writing more robust scripts in which unhandled errors are preferably fatal.
It does so by enforcing and exploiting selected *bashisms* and sometimes moving away from
IEEE POSIX P1003.2/ISO 9945.2. It supplements bash as a collection of modules akin to a *script
development library*. It consists mostly in pure bash functions with very few dependencies.

Bashkit is a scripting model that proposes idioms and tools for:

* fail fast scripting
* avoiding some bash scripting pitfalls
* runtime error handling and event logging

Bashkit comes with 7 *core* and 11 *standard* function modules. A bashkit script is a bash script that, at some point *sources* bashkit and modules and starts calling their functions. *Custom modules* are easy to write and module boilerplates are kept small. Nonetheless, a proper error handling surely requires editing.

Core modules implement:

* *revised control flows*
* *ANSI color for the masses*
* *error code handling*
* *exhaustive error scheme*
* *advanced logging routines*
* *thorough signal trap handling*
* *stateful bashkit versionning*

Standard modules bring:

* *easy array manipulations*
* *advanced checking, including variable type checking*
* *curl download integration*
* *yes/no interaction support*
* *json conversions*
* *patch integration*
* *file permissions conversion*
* *readlink as a function*
* *shopt stacking*
* *semver comparison*
* *string manipulations*

# Download
Stable releases can be found at [wuage](<https://github.com/Wuageorg/bashkit>).

# Documentation
Documentation for Bashkit is available [online](<http://bashkit.wuage.io>). You may also find information on Bashkit by running TODO.

# Mailing Lists
TODO

# Getting involved
TODO

## Development
TODO

## Translating Bashkit
TODO

## Maintainer
TODO
