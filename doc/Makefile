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

.PHONY: $(.PHONY) all manual clean html pdf man

## Output directory
OUT ?= out
## Source directory
SRC ?= src
## Output filename without extension
OUTPUT_FILENAME ?= manual

# Input doc files
SRCS_MAN_MARKDOWN = $(call rwildcard,$(SRC)/04-man/,*.md)
SRCS_CHAPTERS_MARKDOWN = $(wildcard $(SRC)/*.md)

OUTS_MAN = $(patsubst $(SRC)/%,$(OUT)/%,$(patsubst %.md,%.roff,$(SRCS_MAN_MARKDOWN) $(SRCS_CHAPTERS_MARKDOWN)))
# Output md files
OUTS_PROCESSED_MD = $(patsubst $(SRC)/%,$(OUT)/%,$(patsubst %.md,%.processed.md,$(SRCS_MAN_MARKDOWN)))

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
HTML_ARGS = --template templates/html.html --standalone --to html5
PDF_ARGS = --standalone --pdf-engine xelatex --to pdf
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

html: $(OUT)/$(OUTPUT_FILENAME).html $(EXTRA_DEPS) ## Build html

pdf: $(OUT)/$(OUTPUT_FILENAME).pdf $(EXTRA_DEPS) ## Build pdf

man: $(OUTS_MAN) $(EXTRA_DEPS) ## Build manpage

md: $(OUT)/$(OUTPUT_FILENAME).md $(EXTRA_DEPS) ## Build markdown

# Merging rules

$(OUT)/$(OUTPUT_FILENAME).md: $(SRCS_CHAPTERS_MARKDOWN) $(OUTS_PROCESSED_MD)
	@$(MD) $(@D) # Create target directory
	@$(PD) $(PD_ARGS) --from markdown $^ --to markdown -o $@

$(OUT)/$(OUTPUT_FILENAME).pdf: $(SRCS_CHAPTERS_MARKDOWN) $(OUTS_PROCESSED_MD)
	@$(MD) $(@D) # Create target directory
	@$(PD) $(PD_ARGS) $(PDF_ARGS) --from markdown $^ --to pdf -o $@

$(OUT)/$(OUTPUT_FILENAME).html: $(SRCS_CHAPTERS_MARKDOWN) $(OUTS_PROCESSED_MD)
	@$(MD) $(@D) # Create target directory
	@$(PD) $(PD_ARGS) $(HTML_ARGS) --from markdown $^ --to html -o $@

# Per file rules

$(OUT)/%.processed.md: $(SRC)/%.md
	@$(MD) $(@D) # Create target directory
	@awk 'BEGIN { title=""; out=1; } /^title:/ { title=$$2; } /^---$$/ { out=!out; next; } /# AUTHORS/,/full documentation./ {next} { sub(/NAME/, title); if ($$0 ~ "^#" && $$2 != title ) sub(/# /, "### "); if (out) print > "$@"; }' $<

$(OUT)/%.roff: $(SRC)/%.md
	@$(MD) $(@D) # Create target directory
	@$(PD) $(MAN_ARGS) $< -o $@

