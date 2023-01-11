#!/usr/bin/env make
# Sensible Makefile defaults, inspired from
# https://tech.davis-hansson.com/p/make/
# (ɔ) 2022 wuage.org

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL: # run shell commands as one single shell session
.DELETE_ON_ERROR: # target file deleted on error, guards against broken files
.SUFFIXES: # delete the default suffixes, same as `--no-builtin-rules`
LOCAL_MAKEFLAGS = --warn-undefined-variables --no-print-directory
MAKEFLAGS += $(LOCAL_MAKEFLAGS)
unexport MAKEFLAGS MFLAGS # no arguments to sub-make

.DEFAULT_GOAL := help
.PHONY: $(.PHONY) help

MAKEOVERRIDES ?=

# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@printf '%s%b%s%b%s\n' '-------------------------------- ' '\033[31m' 'TARGETS' '\033[39m' ' -----------------------------------------------------'
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk -v target_ml=56 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-" target_ml "s\033[39m %s\n", $$1, $$2}' | awk '{print NR%2 ? $$0 : "\033[48;5;236m" $$0 "\033[49m" }'
	@printf '%s%b%s%b%s\n' '-------------------------------- ' '\033[31m' 'OPTIONS' '\033[39m' ' -----------------------------------------------------'
	@awk '/^##.*$$/,/?=/ { if ($$0 ~ /?=/) { printf "%s %s\n", $$0, comm } }; { comm=$$0 }' $(MAKEFILE_LIST) | sort | awk -v key_ml=23 -v value_ml=32 'BEGIN {FS = ".=| ## "}; { val=$$2; val_len=length(val); if (val_len > value_ml) { mid = int(value_ml / 2); val=sprintf("%s...%s", substr(val, 0, mid), substr(val, val_len - mid + 4, val_len)); } printf "\033[36m%-" key_ml "s\033[39m=\033[35m%-" value_ml "s\033[39m %s\n", $$1, val, $$3}' | awk '{print NR%2 ? $$0 : "\033[48;5;236m" $$0 "\033[49m"  }'

# Make does not offer a recursive wildcard function, so here's one (https://stackoverflow.com/a/12959764)
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

.PHONY: $(.PHONY) all manual clean epub html pdf docx man

## Output directory
OUT ?= out
## Source directory
SRC ?= src
## Output filename without extension
OUTPUT_FILENAME ?= manual

# Input doc files
SRCS_MARKDOWN = $(call rwildcard,$(SRC)/,*.md)
# Output troff files
OUTS_MAN = $(patsubst $(SRC)/%,$(OUT)/%,$(patsubst %.md,%.roff,$(SRCS_MARKDOWN)))
# Output pdf files
OUTS_PDF = $(patsubst $(SRC)/%,$(OUT)/%,$(patsubst %.md,%.pdf,$(SRCS_MARKDOWN)))
# Output html files
OUTS_HTML = $(patsubst $(SRC)/%,$(OUT)/%,$(patsubst %.md,%.html,$(SRCS_MARKDOWN)))

METADATA = metadata.yaml
TOC = --toc --toc-depth 2
METADATA_ARGS = --metadata-file $(METADATA)
MATH_FORMULAS = --webtex

# Debugging

DEBUG_ARGS = --verbose

PD_ARGS = $(TOC) $(MATH_FORMULAS) $(METADATA_ARGS) $(DEBUG_ARGS)

PD = pandoc
MD = mkdir -p
RM = rm -rf

# Per-format options
# EPUB_ARGS = --template templates/epub.html
HTML_ARGS = --template templates/html.html --to html5
PDF_ARGS = --pdf-engine xelatex --to pdf
MAN_ARGS = --verbose --standalone --to man

TEMPLATES = $(call rwildcard,templates/,*)
EXTRA_DEPS = $(METADATA) $(MAKEFILE_LIST) $(TEMPLATES)

all:	doc ## Build all

doc:	man epub html pdf ## Build documentation for every target formats

clean: ## Clean
	@$(RM) -rf $(OUT)

####################################################################################################
# File builders
####################################################################################################

html:	$(OUT)/$(OUTPUT_FILENAME).html $(EXTRA_DEPS) ## Build html

pdf:	$(OUT)/$(OUTPUT_FILENAME).pdf $(EXTRA_DEPS) ## Build pdf

man: $(OUT)/$(OUTPUT_FILENAME).man $(EXTRA_DEPS) ## Build manpage

# Merging rules

$(OUT)/$(OUTPUT_FILENAME).man: $(OUTS_MAN)
	@$(MD) $(@D) # Create target directory
	@$(PD) $(PD_ARGS) $(MAN_ARGS) --from man $^ --to man -o $@

$(OUT)/$(OUTPUT_FILENAME).pdf: $(OUTS_PDF)
	@$(MD) $(@D) # Create target directory
	@$(PD) $(PD_ARGS) $(PDF_ARGS) --from pdf $^ --to pdf -o $@

$(OUT)/$(OUTPUT_FILENAME).html: $(OUTS_HTML)
	@$(MD) $(@D) # Create target directory
	@$(PD) $(PD_ARGS) $(HTML_ARGS) --from html $^ --to html -o $@

# Per file rules

$(OUT)/%.man: $(SRC)/%.md
	@$(MD) $(@D) # Create target directory
	@$(PD) $(MAN_ARGS) $< -o $@

$(OUT)/%.pdf: $(SRC)/%.md
	@$(MD) $(@D) # Create target directory
	@$(PD) $(PDF_ARGS) $< -o $@

$(OUT)/%.html: $(SRC)/%.md
	@$(MD) $(@D) # Create target directory
	@$(PD) $(HTML_ARGS) $< -o $@
