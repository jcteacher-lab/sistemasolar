# 📘 Guía de Ejercicios · Sistema Solar

Guía académica en LaTeX que acompaña al **Simulador del Sistema Solar**. Usa el simulador como laboratorio virtual para aplicar las leyes de Kepler y la gravitación universal.

## Contenido

- Portada institucional con datos del autor.
- Marco teórico completo (Kepler, Newton, cantidades orbitales).
- 6 bloques de ejercicios con tablas, cálculos y proyecto final.
- Apéndices: constantes, datos de referencia para el docente, rúbrica.
- Bibliografía con 8 referencias.

## Requisitos

- **TeX Live** (Linux/macOS) o **MiKTeX** (Windows).
- Paquetes: `babel-spanish`, `siunitx`, `tcolorbox`, `longtable`, `fancyhdr`, `hyperref`, `mdframed`, `lastpage`.

Instalación rápida en Debian/Ubuntu:

```bash
sudo apt install texlive-latex-extra texlive-lang-spanish texlive-science
```

En macOS (con Homebrew):

```bash
brew install --cask mactex
```

## Compilar

```bash
# Desde esta carpeta
make

# O manualmente
pdflatex guia-ejercicios.tex
pdflatex guia-ejercicios.tex
```

El PDF resultante es `guia-ejercicios.pdf`.

## Personalizar

Edita el bloque **"DATOS DEL AUTOR"** al inicio de `guia-ejercicios.tex`:

```latex
\newcommand{\autor}{<<TU NOMBRE COMPLETO>>}
\newcommand{\institucion}{<<TU INSTITUCIÓN / UNIVERSIDAD>>}
\newcommand{\facultad}{<<FACULTAD / DEPARTAMENTO>>}
\newcommand{\asignatura}{<<ASIGNATURA / CURSO>>}
\newcommand{\profesor}{<<PROFESOR / TUTOR>>}
\newcommand{\correo}{<<tu.correo@institucion.edu>>}
\newcommand{\ciudad}{<<CIUDAD, PAÍS>>}
```

## Estructura del `.tex`

| Sección | Descripción |
|---|---|
| Preámbulo | Paquetes, colores, cajas, comandos. |
| Portada | `titlepage` con datos institucionales. |
| Resumen | Caja destacada con resumen ejecutivo. |
| Índice | `\tableofcontents`. |
| Presentación | Objetivos de aprendizaje. |
| Marco teórico | Leyes de Kepler y gravitación universal. |
| Bloques 0–6 | Ejercicios organizados por tema. |
| Apéndices | Constantes, datos del docente, rúbrica. |
| Bibliografía | `thebibliography` con 8 referencias. |

## Overleaf

Si no quieres instalar TeX Live:

1. Crea un proyecto vacío en <https://www.overleaf.com>.
2. Sube `guia-ejercicios.tex`.
3. Pulsa **Recompile**.

## Licencia

GNU GPL v3 — consulta el archivo [`LICENSE`](../../LICENSE) en la raíz del proyecto.