SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

SOURCE := resume.md
OUT ?= site
# Directory of extra font files for Typst. CI sets it; locally the system fonts are used.
FONT_PATH ?=
# SF Pro is only fetched by `make fonts` (CI); locally the system fonts are used.
SF_URL := https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg
SF_FACES := SF-Pro-Text-Regular SF-Pro-Text-RegularItalic SF-Pro-Text-Bold SF-Pro-Text-BoldItalic
# Every extracted face, kept apart from FONT_PATH so CI can cache it.
SF_CACHE ?= sf-fonts
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

.PHONY: all html pdf site verify fonts require-font-path

all: site

# Everything the Pages site serves: index.html links to resume.pdf and resume.md.
site: html pdf $(OUT)/resume.md $(OUT)/.nojekyll

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

$(OUT)/resume.md: $(SOURCE)
	@mkdir -p $(OUT)
	cp -- $(SOURCE) $(OUT)/resume.md

# Tells GitHub Pages to serve the files as-is.
$(OUT)/.nojekyll:
	@mkdir -p $(OUT)
	touch -- $(OUT)/.nojekyll

# Fails if the PDF embeds SF Pro faces the resume should not use.
verify: $(OUT)/resume.pdf
	pdfinfo $(OUT)/resume.pdf | grep -E "Pages|Tagged|Title"
	pdffonts $(OUT)/resume.pdf
	@if pdffonts $(OUT)/resume.pdf | grep -E "Heavy|Black|Rounded"; then \
		echo "Unexpected font face in $(OUT)/resume.pdf" >&2; exit 1; \
	fi

# Copies the faces the resume uses into FONT_PATH, downloading SF Pro on first use.
fonts: require-font-path $(SF_CACHE)/$(firstword $(SF_FACES)).otf
	@mkdir -p $(FONT_PATH)
	for face in $(SF_FACES); do cp -- $(SF_CACHE)/$$face.otf $(FONT_PATH)/; done

$(SF_CACHE)/$(firstword $(SF_FACES)).otf:
	tmp=$$(mktemp -d); \
	trap 'hdiutil detach "$$tmp/mnt" -quiet 2>/dev/null || true; rm -rf "$$tmp"' EXIT; \
	curl -fsSL -o "$$tmp/SF-Pro.dmg" "$(SF_URL)"; \
	mkdir "$$tmp/mnt"; \
	hdiutil attach "$$tmp/SF-Pro.dmg" -nobrowse -mountpoint "$$tmp/mnt" >/dev/null; \
	pkgutil --expand-full "$$tmp/mnt/SFProFonts.pkg" "$$tmp/pkg"; \
	mkdir -p $(SF_CACHE); \
	find "$$tmp/pkg" -name '*.otf' -exec cp {} $(SF_CACHE)/ \;; \
	test -f $@

require-font-path:
	@test -n "$(FONT_PATH)" || { echo "Set FONT_PATH to the directory for the fonts" >&2; exit 1; }
