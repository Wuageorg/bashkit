#!/usr/bin/env bash
# helper.bash --
# wuage bash script devkit test suite
# adapted from:
# https://github.com/ko1nksm/readlinkf/blob/master/helper.sh
# ----
# (ɔ) 2022 wuage.org

if [[ "${OSTYPE}" == 'darwin'* ]]; then
    readlink() {
        greadlink "$@"
    }
fi

make_dir() {
  mkdir -p "$1"
}

make_file() {
  mkdir -p "$(dirname "$1")"
  touch "$1"
}

make_link() {
  from=${1#*" -> "} to=${1%" -> "*}
  mkdir -p "$(dirname "$to")"
  run ln -snf "$from" "$to"
}


CDPATH=${BATS_TEST_TMPDIR}

make_file "${BATS_TEST_TMPDIR}/RLF-BASE/FILE"
make_dir  "${BATS_TEST_TMPDIR}/RLF-BASE/DIR"
make_link "${BATS_TEST_TMPDIR}/RLF-BASE/LINK -> FILE"
make_link "${BATS_TEST_TMPDIR}/RLF-BASE/LINK2 -> DIR"
make_file "${BATS_TEST_TMPDIR}/RLF-BASE/LINK2/FILE"
make_link "${BATS_TEST_TMPDIR}/RLF-BASE/PARENT -> ../"
make_link "${BATS_TEST_TMPDIR}/RLF-BASE/PARENT2 -> ../RLF-BASE"
make_link "${BATS_TEST_TMPDIR}/RLF-BASE1 -> /RLF-BASE"
make_link "${BATS_TEST_TMPDIR}/RLF-BASE/DIR/LINK1 -> ../FILE"
make_link "${BATS_TEST_TMPDIR}/RLF-BASE/DIR/LINK2 -> ./LINK1"
make_link "${BATS_TEST_TMPDIR}/RLF-BASE/DIR/LINK3 -> ../../RLF-LINK"
make_link "${BATS_TEST_TMPDIR}/RLF-BASE/DIR/LINK4 -> ../../RLF-LINK-BROKEN"
make_link "${BATS_TEST_TMPDIR}/RLF-LINK -> RLF-BASE/DIR/LINK1"
make_link "${BATS_TEST_TMPDIR}/RLF-LINK-BROKEN -> RLF-TMP/DIR/FILE"
make_link "${BATS_TEST_TMPDIR}/RLF-LOOP1 -> ./RLF-LOOP2"
make_link "${BATS_TEST_TMPDIR}/RLF-LOOP2 -> ./RLF-LOOP1"
make_link "${BATS_TEST_TMPDIR}/RLF-MISSING -> ./RLF-NO_FILE"
make_link "${BATS_TEST_TMPDIR}/RLF-ROOT -> ${BATS_TEST_TMPDIR}"
make_file "${BATS_TEST_TMPDIR}/RLF-SPACE INCLUDED/FILE NAME"
make_link "${BATS_TEST_TMPDIR}/RLF-SPACE INCLUDED/DIR NAME/SYMBOLIC LINK -> ../FILE NAME"

cleanup() {
    rm -rf "/RLF-BASE"
    rm -rf "/RLF-BASE1"
    rm -rf "/RLF-LINK"
    rm -rf "/RLF-LINK-BROKEN"
    rm -rf "/RLF-LOOP1"
    rm -rf "/RLF-LOOP2"
    rm -rf "/RLF-MISSING"
    rm -rf "/RLF-ROOT"
    rm -rf "/RLF-SPACE INCLUDED"
}

compare_with_readlink() {
  # shellcheck disable=SC2230
  link=$(readlink -f "$1") &&:; set -- "$@" "${link}" "$?"
  link=$(readlinkf "$1") &&:; set -- "$@" "${link}" "$?"

  [[ "$2($3)" = "$4($5)" ]]
}

pathes() {
  # echo "/RLF-BASE/FILE"
  # return # if you want to run only specified path
  {
    set +u
    find /RLF-*
    echo "/RLF-BASE/LINK2/FILE"
    echo "/RLF-BASE/DIR/../FILE"
    echo ""
    echo "."
    echo "../"
    echo "./RLF-NONE/../"
  } | sort | while IFS= read -r pathname; do
    echo "${pathname}"
    echo "${pathname}/"
  done
}

tests() {
  local ex=0 cwd=${BATS_TEST_TMPDIR}
  while IFS= read -r pathname; do
    echo $
    cd "${cwd}" || exit 1  # absolute path
    compare_with_readlink "${pathname}" || ex=1

    cd / # relative path from current directory
    compare_with_readlink "${pathname#/}" || ex=1

    cd /usr/bin || exit 1  # relative path from other directory
    compare_with_readlink "../..${pathname}" || ex=1

    cd /RLF-BASE1 || exit 1  # on the symlink directory
    compare_with_readlink "${pathname#/}" || ex=1
  done

  return "${ex}"
}


