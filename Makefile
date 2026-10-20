# =====================================================================
#  Makefile raíz del proyecto Simulador del Sistema Solar
# =====================================================================

.PHONY: all guia simulador clean dist clean-guia help

all: guia
	@echo "✅ Proyecto compilado. Abre index.html en tu navegador."

help:
	@echo "Objetivos disponibles:"
	@echo "  make guia       — Compila la guía de ejercicios en PDF"
	@echo "  make simulador  — Sirve el simulador en http://localhost:8000"
	@echo "  make clean      — Borra archivos auxiliares de LaTeX"
	@echo "  make dist       — Empaqueta el proyecto en un .zip"
	@echo "  make all        — Sinónimo de 'make guia'"

guia:
	@echo "📘 Compilando la guía de ejercicios..."
	$(MAKE) -C docs/guia-ejercicios

simulador:
	@echo "🌐 Sirviendo el simulador en http://localhost:8000"
	python3 -m http.server 8000

clean:
	$(MAKE) -C docs/guia-ejercicios clean

dist: guia
	@echo "📦 Empaquetando proyecto..."
	@rm -f simulador-sistema-solar.zip
	@zip -r simulador-sistema-solar.zip \
		README.md LICENSE index.html Makefile .gitignore \
		docs/ -x "*.aux" "*.log" "*.out" "*.toc" "*.synctex.gz" \
		      "*.fls" "*.fdb_latexmk" "*.bbl" "*.blg"
	@echo "✅ Listo: simulador-sistema-solar.zip"