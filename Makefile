SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

SOURCE := resume.md
OUT ?= site
TITLE := Tran Pham Hoang Duy – Staff Software Engineer

PDF_FLAGS := --pdf-engine=typst -V mainfont=Times

.PHONY: all html pdf site verify

all: site

# Everything the Pages site serves: index.html links to resume.pdf and resume.md.
site: html pdf $(OUT)/resume.md $(OUT)/.nojekyll

html: $(OUT)/index.html

pdf: $(OUT)/resume.pdf

$(OUT)/index.html: $(SOURCE) Makefile
	@mkdir -p $(OUT)
	pandoc $(SOURCE) -s --metadata lang=en --metadata pagetitle="$(TITLE)" \
		-B <(echo '<p><a href="resume.pdf">Download PDF</a> · <a href="resume.md">Markdown</a></p>') \
		-o $(OUT)/index.html

$(OUT)/resume.pdf: $(SOURCE) Makefile
	@mkdir -p $(OUT)
	pandoc $(SOURCE) $(PDF_FLAGS) -o $(OUT)/resume.tmp.pdf
	@mv -- $(OUT)/resume.tmp.pdf $(OUT)/resume.pdf

$(OUT)/resume.md: $(SOURCE)
	@mkdir -p $(OUT)
	cp -- $(SOURCE) $(OUT)/resume.md

# Tells GitHub Pages to serve the files as-is.
$(OUT)/.nojekyll:
	@mkdir -p $(OUT)
	touch -- $(OUT)/.nojekyll

# Report the generated PDF and reject unembedded fonts.
verify: $(OUT)/resume.pdf
	pdfinfo $(OUT)/resume.pdf | grep -E "Pages|Tagged|Title"
	pdffonts $(OUT)/resume.pdf
	@pdffonts $(OUT)/resume.pdf | awk 'NR > 2 && $$(NF-4) != "yes" { bad=1 } END { exit bad }' || { \
		echo "Unembedded font in $(OUT)/resume.pdf" >&2; exit 1; \
	}
