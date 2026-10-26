# Simulador del Sistema Solar

[![Licencia: GPL v3](https://img.shields.io/badge/Licencia-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![HTML5](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)]()
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)]()
[![LaTeX](https://img.shields.io/badge/LaTeX-008080?logo=latex&logoColor=white)]()
[![Sin dependencias](https://img.shields.io/badge/dependencias-ninguna-success)]()

Simulador interactivo del Sistema Solar en un único archivo HTML. Renderiza planetas y lunas con **órbitas keplerianas reales** (elementos J2000), rastros de trayectoria, panel de datos físicos por cuerpo y control total de cámara (zoom, desplazamiento e inclinación). Diseñado para crecer: el motor ya soporta añadir asteroides, cometas o planetas enanos sin tocar el código de renderizado.
https://jcteacher-lab.github.io/sistemasolar/

Incluye una **guía de ejercicios académica en LaTeX** que usa el simulador como laboratorio virtual para aplicar las leyes de Kepler y la gravitación universal.

---

## Tabla de contenidos

- [Características](#-características)
- [Uso rápido](#-uso-rápido)
- [Estructura del repositorio](#-estructura-del-repositorio)
- [Controles](#-controles)
- [Arquitectura del código](#-arquitectura-del-código)
- [Modelo físico](#-modelo-físico)
- [Cómo añadir nuevos astros](#-cómo-añadir-nuevos-astros)
- [Documentación académica](#-documentación-académica)
- [Roadmap](#-roadmap)
- [Limitaciones conocidas](#-limitaciones-conocidas)
- [Contribuir](#-contribuir)
- [Referencias](#-referencias)
- [Licencia](#-licencia)
- [Agradecimientos](#-agradecimientos)

---

## Características

- **Órbitas reales** basadas en elementos keplerianos J2000 (`a`, `e`, `i`, `Ω`, `ϖ`, `L`, `P`) resueltos con la ecuación de Kepler.
- **Motor jerárquico** Sol → planetas → lunas (posiciones relativas al cuerpo padre).
- **Rastros de trayectoria** con longitud limitada y desvanecimiento suave.
- **Panel de datos** por cuerpo seleccionado: masa, radio, semieje mayor, excentricidad, inclinación, periodo, distancia al primario, velocidad orbital (vis-viva) y aceleración gravitatoria.
- **Zoom profundo** (×0.1 hasta ×60 000): desde Neptuno completo hasta la órbita de la Luna.
- **Inclinación de vista** ajustable (0°–80°) para apreciar la tridimensionalidad de las órbitas.
- **Escala visible**: barra de escala dinámica y aviso de exageración de tamaños cuando se aplica.
- **Modo escala real** para comparar tamaños verdaderos.
- **Presets de cámara**: sistema completo, interiores, Tierra–Luna.
- **Sin dependencias**: HTML + CSS + JavaScript puro.
- **Guía de ejercicios en LaTeX** con marco teórico de Kepler y gravitación universal.

---

## Uso rápido

1. Descarga o copia el contenido del simulador en un archivo llamado `index.html`.
2. Ábrelo con doble clic en cualquier navegador moderno (Chrome, Firefox, Edge, Safari).
3. Listo. No requiere servidor web ni conexión a internet.

```bash
git clone https://github.com/jcteacher-lab/sistemasolar.git
cd sistemasolar
python3 -m http.server 8000
# Luego abre en tu navegador:
http://localhost:8000
```

---

## Estructura del repositorio

```
sistemasolar/
├── README.md                          ← este archivo
├── LICENSE                            ← texto legal GNU GPL v3
├── index.html                         ← el simulador
├── Makefile                           ← compila todo (simulador + guía)
├── .gitignore                         ← exclusiones para Git
└── docs/
    ├── guia-ejercicios/
    │   ├── guia-ejercicios.tex        ← guía académica en LaTeX
    │   ├── Makefile                   ← compila solo la guía
    │   ├── bibliografia.bib           ← referencias BibTeX (opcional)
    │   └── README.md                  ← instrucciones de compilación
    └── capturas/
        └── .gitkeep                   ← placeholder de capturas
```

### Archivos principales

| Archivo | Descripción |
|---|---|
| `index.html` | Simulador completo, autocontenido. |
| `docs/guia-ejercicios/guia-ejercicios.tex` | Guía de ejercicios académica (portada, marco teórico, 6 bloques de ejercicios, apéndices, bibliografía). |
| `Makefile` | Compila el PDF de la guía y sirve el simulador localmente. |
| `LICENSE` | Texto legal completo de la GNU GPL v3. |

---

## Controles

### Ratón / trackpad

| Acción | Resultado |
|---|---|
| Arrastrar | Desplazar la cámara |
| Rueda del ratón | Zoom hacia el cursor |
| Clic sobre un cuerpo | Seleccionar y ver sus datos |

### Teclado

| Tecla | Acción |
|---|---|
| `Espacio` | Pausar / reanudar |
| `+` / `-` | Zoom in / zoom out al centro |
| `Esc` | Deseleccionar cuerpo |

### Botones de la interfaz

- **Sistema completo** — encuadra desde el Sol hasta Neptuno.
- **Interiores** — Mercurio a Marte.
- **Tierra–Luna** — zoom extremo al sistema Tierra–Luna con seguimiento activado.
- **Pausa / Reanudar** — control del flujo temporal.
- **Rastros** — muestra u oculta las trayectorias dibujadas.
- **Órbitas** — muestra u oculta las elipses teóricas.
- **Escala real** — desactiva la exageración de tamaños.
- **Velocidad del tiempo** — de 0 a 400 días simulados por segundo real.
- **Inclinación de vista** — de 0° (vista cenital) a 80° (casi lateral).
- **Seguir selección** — la cámara se centra en el cuerpo elegido.
- **Órbitas de lunas** — activa o desactiva las órbitas de los satélites.

---

## Arquitectura del código

El archivo se divide en 11 secciones numeradas y comentadas:

| Sección | Contenido |
|---|---|
| 1. Constantes | Factores de conversión (UA, masas, GM, época J2000). |
| 2. Catálogo | Array `CATALOG` con todos los cuerpos. |
| 3. Utilidades orbitales | `solveKepler`, `relPos`, `orbitPoints`. |
| 4. Estado global | Cámara, tiempo, flags de visualización. |
| 5. Cámara y proyección | Transformación mundo→pantalla. |
| 6. Renderizado | `drawOrbits`, `drawTrails`, `drawBodies`, `drawScaleBar`. |
| 7. Bucle principal | Integración temporal + rastros + `requestAnimationFrame`. |
| 8. Panel de datos | Generación del HTML del panel. |
| 9. Interacción | Ratón, teclado y *picking*. |
| 10. Controles | Vinculación de botones y sliders. |
| 11. Arranque | `resize`, estrellas, primer frame. |

---

## Modelo físico

### Posición orbital

Para cada cuerpo con elementos `(a, e, i, Ω, ϖ, L, P)` y tiempo `t` en días desde J2000:

1. **Anomalía media**: `M = L + n·t − ϖ` con `n = 2π / P`.
2. **Anomalía excéntrica** `E`: Newton-Raphson sobre `E − e·sin E = M`.
3. **Posición en el plano orbital**:
   - `x_v = a·(cos E − e)`
   - `y_v = a·√(1−e²)·sin E`
4. **Rotación por argumento del periastro** `ω = ϖ − Ω`.
5. **Rotación por inclinación** `i`.
6. **Rotación por ascensión del nodo** `Ω`.

### Datos derivados

- **Velocidad orbital** (vis-viva): `v = √(GM · (2/r − 1/a))`.
- **Aceleración gravitatoria**: `g = GM / r²`.
- **Escala de dibujo**: píxeles reales vs. dibujados, con factor de exageración.

---

## Cómo añadir nuevos astros

Añade entradas al array `CATALOG`:

```javascript
{
  id: 'ceres',
  name: 'Ceres',
  kind: 'Planeta enano',
  parent: 'sun',
  radius: 473,              // km
  mass: 9.3835e20,          // kg
  gm: 6.263e10,             // m³/s²
  color: '#9b8f7d',
  el: { a: 2.766, e: 0.0760, i: 10.594, om: 80.393, wbar: 73.597, L: 95.989 },
  P: 1681.63                // días
}
```

**Campos obligatorios:**

| Campo | Descripción |
|---|---|
| `id` | Identificador único (string). |
| `name` | Nombre para mostrar. |
| `kind` | Categoría (`Planeta`, `Satélite`, `Planeta enano`, …). |
| `parent` | `id` del cuerpo padre, o `null` si es raíz. |
| `radius` | Radio en km. |
| `mass` | Masa en kg. |
| `color` | Color CSS del cuerpo. |
| `el` | Elementos keplerianos (obligatorio si `parent ≠ null`). |
| `P` | Periodo orbital en días. |
| `gm` | Parámetro gravitacional estándar (m³/s²). |

>  Consulta el [README de la guía](docs/guia-ejercicios/README.md) para más detalles sobre el catálogo.

---

## Documentación académica

El proyecto incluye una **guía de ejercicios académica en LaTeX** pensada para usar el simulador como laboratorio virtual en cursos de física, astronomía o mecánica celeste.

### Contenido de la guía

| Sección | Descripción |
|---|---|
| **Portada institucional** | Con datos del autor, institución, asignatura y fecha. |
| **Resumen y palabras clave** | Resumen ejecutivo del material didáctico. |
| **Presentación** | Objetivos de aprendizaje y cómo usar la guía. |
| **Marco teórico** | Leyes de Kepler (con deducción de la 3.ª ley desde Newton), gravitación universal, cantidades orbitales derivadas (vis-viva, aceleración, escape, densidad). |
| **Bloque 0** | Familiarización con el simulador. |
| **Bloque 1** | Tablas de datos de los 8 planetas (radio, masa, a, e, i, T, perihelio, afelio, v). |
| **Bloque 2** | Tablas de datos de las 16 lunas principales. |
| **Bloque 3** | Ejercicios de las tres leyes de Kepler, incluida la verificación numérica de T²/a³. |
| **Bloque 4** | Gravitación universal: fuerza, aceleración, gravedad superficial, velocidad de escape. |
| **Bloque 5** | Cantidades orbitales: vis-viva, comparación de velocidades, satélites artificiales. |
| **Bloque 6** | Proyecto final: añadir un astro al catálogo, investigación corta, pregunta abierta. |
| **Apéndices** | Constantes y fórmulas, datos de referencia para el docente, rúbrica de evaluación. |
| **Bibliografía** | 8 referencias (Kepler, Newton, NASA JPL, IAU, Vallado, Murray & Dermott). |

### Compilar la guía

#### Requisitos

- **TeX Live** (Linux/macOS) o **MiKTeX** (Windows), con los paquetes `babel-spanish`, `siunitx`, `tcolorbox`, `longtable`, `fancyhdr`, `hyperref`.
- **Overleaf** (alternativa sin instalación).

#### Compilación local

```bash
# Desde la raíz del proyecto
make guia

# O manualmente
cd docs/guia-ejercicios
pdflatex guia-ejercicios.tex
pdflatex guia-ejercicios.tex   # segunda pasada para referencias e índice
```

El PDF resultante queda en `docs/guia-ejercicios/guia-ejercicios.pdf`.

#### Compilación en Overleaf

1. Crea un proyecto vacío en <https://www.overleaf.com>.
2. Sube `docs/guia-ejercicios/guia-ejercicios.tex`.
3. Pulsa **Recompile**.

### Personalizar la guía

Busca el bloque **"DATOS DEL AUTOR"** al inicio de `guia-ejercicios.tex`:

```latex
\newcommand{\autor}{<<TU NOMBRE COMPLETO>>}
\newcommand{\institucion}{<<TU INSTITUCIÓN / UNIVERSIDAD>>}
\newcommand{\facultad}{<<FACULTAD / DEPARTAMENTO>>}
\newcommand{\asignatura}{<<ASIGNATURA / CURSO>>}
\newcommand{\profesor}{<<PROFESOR / TUTOR>>}
\newcommand{\correo}{<<tu.correo@institucion.edu>>}
\newcommand{\ciudad}{<<CIUDAD, PAÍS>>}
```

Sustituye cada `<<...>>` por tus datos.

---

## Roadmap

- [x] Planetas del Sistema Solar con elementos J2000 reales.
- [x] Principales lunas de Marte, Júpiter, Saturno, Urano y Neptuno.
- [x] Rastros, panel de datos, zoom profundo, inclinación de vista.
- [x] Guía de ejercicios académica en LaTeX (Kepler, gravitación, tablas, rúbrica).
- [ ] **Cinturón de asteroides** (grupo de cuerpos con órbitas distribuidas).
- [ ] **Cinturón de Kuiper** y planetas enanos (Ceres, Plutón, Eris, Makemake, Haumea).
- [ ] **Cometas** con alta excentricidad e inclinación.
- [ ] **Anillos de Saturno** como geometría dedicada.
- [ ] **Texturas** opcionales por planeta.
- [ ] **Búsqueda** de cuerpos por nombre.
- [ ] **Persistencia** del estado de cámara en `localStorage`.
- [ ] **Modo efemérides**: introducir una fecha y saltar a ella.
- [ ] **Versión en inglés** de la guía de ejercicios.

---

## Limitaciones conocidas

- **Lunas simplificadas**: los elementos orbitales de los satélites son aproximados (valores promedio). No se modelan perturbaciones ni precesión.
- **Escala de tamaños exagerada por defecto**: mínimo de 2.6 px para visibilidad. El HUD indica cuándo se aplica exageración.
- **Cálculo en CPU con Canvas 2D**: apto para decenas de cuerpos; no optimizado para miles de asteroides simultáneos.
- **Sin física N-cuerpos**: cada cuerpo sigue su órbita kepleriana alrededor de su padre sin influencia de otros.

---

## Contribuir

Este proyecto es software libre bajo GPL v3 y **todas las contribuciones son bienvenidas**.

1. Haz *fork* del repositorio.
2. Crea una rama: `git checkout -b feature/cinturon-asteroides`.
3. Haz commit: `git commit -m "feat: añade cinturón de asteroides"`.
4. Haz push: `git push origin feature/cinturon-asteroides`.
5. Abre un *pull request*.

### Buenas prácticas

- Mantén el estilo del código (comentarios numerados por sección).
- Si añades cuerpos al `CATALOG`, documenta la fuente de los elementos orbitales.
- Si modificas el motor, actualiza esta documentación (`README.md`).
- Si modificas la guía, recompila el PDF antes de hacer commit.
- Al ser GPL v3, tus contribuciones se integrarán bajo la misma licencia.

### Ideas especialmente buscadas

- Catálogo completo de asteroides del cinturón principal.
- Modelo de anillos para Saturno.
- Cálculo de perturbaciones de Júpiter sobre los asteroides.
- Migración del render a WebGL.
- Traducción de la guía al inglés, francés o portugués.

---

## Referencias

- **Elementos orbitales planetarios (J2000)**: NASA JPL, *Approximate Positions of the Planets* — <https://ssd.jpl.nasa.gov/planets/approx_pos.html>
- **Datos físicos de planetas y lunas**: NASA Planetary Fact Sheet — <https://nssdc.gsfc.nasa.gov/planetary/factsheet/>
- **Parámetros gravitacionales estándar (GM)**: IAU 2015 Resolution B3.
- **Ecuación de Kepler y órbitas elípticas**: Vallado, *Fundamentals of Astrodynamics*.

---
## Autor

**MTI. Juan Carlos Santiago Sánchez**
- GitHub: [@jcteacher-lab](https://github.com/jcteacher-lab)
- Correo: juancarlos.santiago.cb161@dgeti.sems.gob.mx

## Licencia

**Simulador del Sistema Solar**

Copyright (C) 2026

Este programa es **software libre**: puedes redistribuirlo y/o modificarlo bajo los términos de la **GNU General Public License** tal como la publica la Free Software Foundation, ya sea la **versión 3** de la Licencia, o (a tu elección) cualquier versión posterior.

Este programa se distribuye con la esperanza de que sea útil, pero **SIN NINGUNA GARANTÍA**; ni siquiera la garantía implícita de **COMERCIABILIDAD** o **IDONEIDAD PARA UN PROPÓSITO PARTICULAR**. Consulta la GNU General Public License para más detalles.

Deberías haber recibido una copia de la GNU General Public License junto con este programa. Si no es así, consulta <https://www.gnu.org/licenses/>.

### Resumen de la licencia

| | |
|---|---|
| **Licencia** | GNU General Public License v3.0 |
| **SPDX** | `GPL-3.0-or-later` |
| **Copyright** | (C) 2026 |
| **Texto legal completo** | [LICENSE](./LICENSE) · [gnu.org/licenses/gpl-3.0](https://www.gnu.org/licenses/gpl-3.0.txt) |

> **Importante**: para que el proyecto esté correctamente licenciado bajo GPL v3, además de este `README.md` debes incluir en la raíz del repositorio un archivo llamado `LICENSE` (sin extensión) con el texto legal completo. Puedes obtenerlo con:
>
> ```bash
> curl -o LICENSE https://www.gnu.org/licenses/gpl-3.0.txt
> ```

---

## Agradecimientos

Inspirado en la larga tradición de simuladores orbitales abiertos (NASA Eyes on the Solar System, Solar System Scope, Orbit Simulator de PhET) y construido con la idea de que **cualquier persona pueda extenderlo añadiendo una línea al catálogo**.

> *"El Sistema Solar no es un lugar, es un proceso."* — Carl Sagan (paráfrasis)

---

**Hecho con ❤️ y con libertad — GPL v3 garantiza que seguirá siendo libre.**


## Proyectos relacionados

- [Simulador de Tiro Parabólico](https://jcteacher-lab.github.io/tiroparabolico) —
  Simulador educativo de movimiento de proyectiles con Canvas 2D.
- [Analizador de parábolas](https://github.com/jcteacher-lab/analizadordeparabolas) —
  Herramienta didáctica para explorar la parábola: cambia a, h y k con deslizadores y observa cómo se traslada el vértice.
