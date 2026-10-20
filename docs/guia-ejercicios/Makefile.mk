# =====================================================================
#  Makefile de la guía de ejercicios en LaTeX
# =====================================================================

TEX      = guia-ejercicios
LATEX    = pdflatex
BIBTEX   = bibtex
LATEXFLAGS = -interaction=nonstopmode -halt-on-error

.PHONY: all clean distclean view

all: $(TEX).pdf

$(TEX).pdf: $(TEX).tex
	$(LATEX) $(LATEXFLAGS) $(TEX).tex
	$(LATEX) $(LATEXFLAGS) $(TEX).tex

# Descomenta las siguientes líneas si usas BibTeX
# $(TEX).pdf: $(TEX).tex bibliografia.bib
# 	$(LATEX) $(LATEXFLAGS) $(TEX).tex
# 	$(BIBTEX) $(TEX)
# 	$(LATEX) $(LATEXFLAGS) $(TEX).tex
# 	$(LATEX) $(LATEXFLAGS) $(TEX).tex

view: $(TEX).pdf
	@xdg-open $(TEX).pdf 2>/dev/null || open $(TEX).pdf 2>/dev/null || \
		echo "Abre manualmente $(TEX).pdf"

clean:
	@rm -f *.aux *.log *.out *.toc *.synctex.gz *.fls \
	       *.fdb_latexmk *.bbl *.blg *.nav *.snm *.vrb

distclean: clean
	@rm -f $(TEX).pdf