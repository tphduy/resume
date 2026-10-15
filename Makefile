SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

SOURCE := resume.md
OUT ?= site
# Directory of extra font files for Typst. CI sets it; locally the system fonts are used.
FONT_PATH ?=
TITLE := Tran Pham Hoang Duy – Staff Software Engineer

PDF_FLAGS := \
	--pdf-engine=typst \
	-V papersize=a4 \
	-V margin.x=18mm \
	-V margin.y=18mm \
	-V fontsize=10pt \
	-V mainfont='SF Pro Text'

ifneq ($(FONT_PATH),)
PDF_FLAGS += --pdf-engine-opt=--font-path --pdf-engine-opt=$(FONT_PATH)
endif

.PHONY: all html pdf

all: html pdf

html: $(OUT)/index.html

pdf: $(OUT)/resume.pdf

$(OUT)/index.html: $(SOURCE)
	@mkdir -p $(OUT)
	pandoc $(SOURCE) -s --metadata lang=en --metadata pagetitle="$(TITLE)" \
		-B <(echo '<p><a href="resume.pdf">Download PDF</a> · <a href="resume.md">Markdown</a></p>') \
		-o $(OUT)/index.html

$(OUT)/resume.pdf: $(SOURCE)
	@mkdir -p $(OUT)
	pandoc $(SOURCE) $(PDF_FLAGS) -o $(OUT)/resume.tmp.pdf
	@mv -- $(OUT)/resume.tmp.pdf $(OUT)/resume.pdf
