# Run from this folder. All modes share presentation.tex and the class/bibliography.
# Distinct job names keep notes, handouts, and slide auxiliary files separate.
.DEFAULT_GOAL := slides
.PHONY: all slides handout notes rebuild clean distclean help
LATEXMK ?= latexmk
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
help:
	@echo "make / make slides : presentation.pdf (audience slides)"
	@echo "make handout       : presentation-handout.pdf (collapsed reveals, no notes/dividers)"
	@echo "make notes         : presentation-notes.pdf (slide left, private notes right)"
	@echo "make all / rebuild : build / force rebuild of all three modes"
	@echo "make clean         : remove auxiliaries, retain PDFs"
	@echo "make distclean     : remove auxiliaries and PDFs, preserve sources"
