# Makefile --
# wuage bash script devkit makefile
# ----
# (ɔ) 2022 wuage.org

all: test count

basedir=$(shell git rev-parse --show-toplevel)

count:
	find . -name '*.bash' | xargs wc -l

wtb := $(basedir)/toolbox
test: $(wildcard *.bash)
	$(wtb) bats -r test/bashkit

.PHONY: count test
