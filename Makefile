SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

SOURCE := resume.md
OUT ?= site
METADATA := metadata.json
METADATA_TOOL := scripts/metadata.py
TITLE := $(shell python3 $(METADATA_TOOL) title)

PDF_FLAGS := --pdf-engine=typst -V mainfont=Times

.PHONY: all html pdf site verify

all: site

# Everything the Pages site serves: index.html links to resume.pdf and resume.md.
site: html pdf $(OUT)/resume.md $(OUT)/.nojekyll $(OUT)/sitemap.xml

html: $(OUT)/index.html

pdf: $(OUT)/resume.pdf

$(OUT)/index.html: $(SOURCE) Makefile $(METADATA) $(METADATA_TOOL)
	@mkdir -p $(OUT)
	pandoc $(SOURCE) -s --metadata lang=en --metadata pagetitle="$(TITLE)" \
		-H <(python3 $(METADATA_TOOL) html) \
		-B <(echo '<p><a href="resume.pdf">Download PDF</a> · <a href="resume.md">Markdown</a></p>') \
		-o $(OUT)/index.html

$(OUT)/resume.pdf: $(SOURCE) Makefile $(METADATA) $(METADATA_TOOL)
	@mkdir -p $(OUT)
	pandoc $(SOURCE) $(PDF_FLAGS) --metadata lang=en \
		-B <(python3 $(METADATA_TOOL) pdf) -o $(OUT)/resume.tmp.pdf
	@mv -- $(OUT)/resume.tmp.pdf $(OUT)/resume.pdf

$(OUT)/resume.md: $(SOURCE)
	@mkdir -p $(OUT)
	cp -- $(SOURCE) $(OUT)/resume.md

# Tells GitHub Pages to serve the files as-is.
$(OUT)/.nojekyll:
	@mkdir -p $(OUT)
	touch -- $(OUT)/.nojekyll

$(OUT)/sitemap.xml: $(METADATA) $(METADATA_TOOL) Makefile
	@mkdir -p $(OUT)
	python3 $(METADATA_TOOL) sitemap > $(OUT)/sitemap.xml

# Check published metadata and basic PDF parsing/accessibility structure.
verify: site
	python3 $(METADATA_TOOL) verify --out $(OUT) --source $(SOURCE)
