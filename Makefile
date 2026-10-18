# Run from this folder. All modes share presentation.tex and the class/bibliography.
# Distinct job names keep notes, handouts, and slide auxiliary files separate.
.DEFAULT_GOAL := slides
.PHONY: all slides handout notes rebuild clean distclean publish help
LATEXMK ?= latexmk
# Publishing settings: override REPO when using this template in another repository.
GH ?= gh
REPO ?= 4sarathbabu/luma
RELEASE_TAG ?= pdf-preview
FLAGS = -norc -pdf -bibtex -interaction=nonstopmode -halt-on-error -file-line-error -synctex=1
# Ignore personal latexmk settings; biblatex selects the working BibTeX backend.
CLEAN_CONFIG = -e '$$clean_ext .= " nav snm vrb bcf run.xml synctex.gz";'
SOURCES = presentation.tex presentation-handout.tex presentation-notes.tex

all: slides handout notes
slides:
	$(LATEXMK) $(FLAGS) presentation.tex
handout:
	$(LATEXMK) $(FLAGS) presentation-handout.tex
notes:
	$(LATEXMK) $(FLAGS) presentation-notes.tex
# Force all three output modes to rebuild after configuration changes.
rebuild:
	$(LATEXMK) $(FLAGS) -g $(SOURCES)
# clean keeps all PDFs; distclean also removes generated PDFs. Sources stay intact.
clean:
	$(LATEXMK) -norc -bibtex $(CLEAN_CONFIG) -c $(SOURCES)
distclean:
	$(LATEXMK) -norc -bibtex $(CLEAN_CONFIG) -C $(SOURCES)

# One-time setup is documented in README.md. Fail before building if unavailable.
# This replaces all three PDFs, including the presenter notes version.
# It does not commit/push source files or move the release's existing Git tag.
publish:
	@command -v "$(GH)" >/dev/null 2>&1 || { echo "GitHub CLI is missing. Install with: brew install gh"; exit 1; }
	$(GH) auth status --hostname github.com
	$(GH) release view "$(RELEASE_TAG)" --repo "$(REPO)" >/dev/null
	$(MAKE) slides handout notes
	$(GH) release upload "$(RELEASE_TAG)" presentation.pdf presentation-handout.pdf presentation-notes.pdf --repo "$(REPO)" --clobber

help:
	@echo "make / make slides : presentation.pdf (audience slides)"
	@echo "make handout       : presentation-handout.pdf (collapsed reveals, no notes/dividers)"
	@echo "make notes         : presentation-notes.pdf (slide left, private notes right)"
	@echo "make all / rebuild : build / force rebuild of all three modes"
	@echo "make clean         : remove auxiliaries, retain PDFs"
	@echo "make distclean     : remove auxiliaries and PDFs, preserve sources"
	@echo "make publish       : build and replace all three PDFs on the existing GitHub release"
