Bashkit is an opiniated scripting model and framework for Bash 5.x. It is intended to help writing more robust scripts in which unhandled errors are preferably fatal. It does so by enforcing and exploiting selected bashisms and sometimes moving away from IEEE POSIX P1003.2/ISO 9945.2. It supplements bash as a collection of modules akin to a script development library. It consists mostly in pure bash functions with few dependencies.

```
source bashkit.bash

isint() {
    local n
    printf -v n '%d' "${1:-}" &> /dev/null \
    || raise "not an int"
}

isint "abc" \
|| error

2022-11-28 12:22:51+0100 [error] isint:5| not an int
```