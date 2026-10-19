# 🌌 Simulador del Sistema Solar

[![Licencia: GPL v3](https://img.shields.io/badge/Licencia-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![HTML5](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)]()
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)]()
[![Sin dependencias](https://img.shields.io/badge/dependencias-ninguna-success)]()

Simulador interactivo del Sistema Solar en un único archivo HTML. Renderiza planetas y lunas con **órbitas keplerianas reales** (elementos J2000), rastros de trayectoria, panel de datos físicos por cuerpo y control total de cámara (zoom, desplazamiento e inclinación). Diseñado para crecer: el motor ya soporta añadir asteroides, cometas o planetas enanos sin tocar el código de renderizado.

---

## 📋 Tabla de contenidos

- [Características](#-características)
- [Uso rápido](#-uso-rápido)
- [Controles](#-controles)
- [Arquitectura del código](#-arquitectura-del-código)
- [Modelo físico](#-modelo-físico)
- [Cómo añadir nuevos astros](#-cómo-añadir-nuevos-astros)
- [Roadmap](#-roadmap)
- [Limitaciones conocidas](#-limitaciones-conocidas)
- [Contribuir](#-contribuir)
- [Referencias](#-referencias)
- [Licencia](#-licencia)
- [Agradecimientos](#-agradecimientos)

---

## ✨ Características

- **Órbitas reales** basadas en elementos keplerianos J2000 (`a`, `e`, `i`, `Ω`, `ϖ`, `L`, `P`) resueltos con la ecuación de Kepler.
- **Motor jerárquico** Sol → planetas → lunas (posiciones relativas al cuerpo padre).
- **Rastros de trayectoria** con longitud limitada y desvanecimiento suave.
- **Panel de datos** por cuerpo seleccionado: masa, radio, semieje mayor, excentricidad, inclinación, periodo, distancia al primario, velocidad orbital (vis-viva) y aceleración gravitatoria.
- **Zoom profundo** (×0.1 hasta ×60 000): desde Neptuno completo hasta la órbita de la Luna.
- **Inclinación de vista** ajustable (0°–80°) para apreciar la tridimensionalidad de las órbitas.
- **Escala visible**: barra de escala dinámica y aviso de exageración de tamaños cuando se aplica.
- **Modo escala real** para comparar tamaños verdaderos (a costa de que planetas pequeños desaparezcan).
- **Presets de cámara**: sistema completo, interiores, Tierra–Luna.
- **Sin dependencias**: HTML + CSS + JavaScript puro. Sin frameworks, sin build, sin instalación.

---

## 🚀 Uso rápido

1. Descarga o copia el contenido del simulador en un archivo llamado `index.html` (o `simulador.html`).
2. Ábrelo con doble clic en cualquier navegador moderno (Chrome, Firefox, Edge, Safari).
3. Listo. No requiere servidor web ni conexión a internet.

```bash
# Opcional: si prefieres servirlo localmente
python3 -m http.server 8000
# luego abre http://localhost:8000/index.html
```

### Estructura del repositorio

```
simulador-sistema-solar/
├── README.md          ← este archivo
├── LICENSE            ← texto completo de la GNU GPL v3
├── index.html         ← el simulador
└── docs/
    └── capturas/
```

---

## 🎮 Controles

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

## 🏗 Arquitectura del código

El archivo se divide en 11 secciones numeradas y comentadas:

| Sección | Contenido |
|---|---|
| 1. Constantes | Factores de conversión (UA, masas, GM, época J2000). |
| 2. Catálogo | Array `CATALOG` con todos los cuerpos y sus elementos orbitales. |
| 3. Utilidades orbitales | `solveKepler`, `relPos`, `orbitPoints`. |
| 4. Estado global | Cámara, tiempo, flags de visualización, construcción del catálogo vivo. |
| 5. Cámara y proyección | Transformación mundo→pantalla con inclinación, zoom y paneo. |
| 6. Renderizado | `drawOrbits`, `drawTrails`, `drawBodies`, `drawScaleBar`. |
| 7. Bucle principal | Integración temporal + gestión de rastros + `requestAnimationFrame`. |
| 8. Panel de datos | Generación del HTML del panel de información. |
| 9. Interacción | Eventos de ratón, teclado y *picking* de cuerpos. |
| 10. Controles | Vinculación de botones, sliders y checkboxes con el estado. |
| 11. Arranque | `resize`, inicialización de estrellas, primer frame. |

### Flujo por fotograma

```
loop(now)
 ├─ avanza simDays según timeScale
 ├─ push punto al trail de cada cuerpo
 ├─ computePositions(simDays)      → posiciones jerárquicas
 ├─ render()
 │   ├─ estrellas de fondo
 │   ├─ drawOrbits()               → elipses cacheadas
 │   ├─ drawTrails()               → polilíneas de rastro
 │   ├─ drawBodies()               → discos + etiquetas
 │   └─ drawScaleBar()
 └─ requestAnimationFrame(loop)
```

---

## 🔭 Modelo físico

### Posición orbital

Para cada cuerpo con elementos `(a, e, i, Ω, ϖ, L, P)` y tiempo `t` en días desde J2000:

1. **Anomalía media**: `M = L + n·t − ϖ` con `n = 2π / P`.
2. **Anomalía excéntrica** `E`: resuelta iterativamente con Newton-Raphson sobre `E − e·sin E = M`.
3. **Posición en el plano orbital**:
   - `x_v = a·(cos E − e)`
   - `y_v = a·√(1−e²)·sin E`
4. **Rotación por argumento del periastro** `ω = ϖ − Ω`.
5. **Rotación por inclinación** `i`.
6. **Rotación por ascensión del nodo** `Ω`.

El resultado es el vector relativo al cuerpo padre. Para lunas, se suma al vector absoluto del planeta (que a su vez suma al Sol).

### Datos derivados en el panel

- **Velocidad orbital** (vis-viva): `v = √(GM_primario · (2/r − 1/a))`.
- **Aceleración gravitatoria**: `a_grav = GM_primario / r²`.
- **Escala de dibujo**: píxeles reales vs. píxeles dibujados, con factor de exageración explícito cuando aplica.

### Escalas

- **Distancias**: `1 px = AU_KM / pxPerAU` (visible en el HUD).
- **Tamaños**: `radio_km / AU_KM × pxPerAU`, con un mínimo de 2.6 px cuando la escala real los haría invisibles.

---

## ➕ Cómo añadir nuevos astros

El motor está pensado para crecer. Solo hay que añadir entradas al array `CATALOG`:

```javascript
// Ejemplo: Ceres, planeta enano del cinturón de asteroides
{
  id: 'ceres',
  name: 'Ceres',
  kind: 'Planeta enano',
  parent: 'sun',
  radius: 473,              // km
  mass: 9.3835e20,          // kg
  gm: 6.263e10,             // m³/s²
  color: '#9b8f7d',
  el: {                     // elementos orbitales
    a: 2.766,               // UA
    e: 0.0760,
    i: 10.594,              // °
    om: 80.393,             // °
    wbar: 73.597,           // °
    L: 95.989               // °
  },
  P: 1681.63                // días
}
```

**Campos obligatorios:**

| Campo | Descripción |
|---|---|
| `id` | Identificador único (string). |
| `name` | Nombre para mostrar. |
| `kind` | Categoría (`Planeta`, `Satélite`, `Planeta enano`, `Asteroide`, `Cometa`, `Estrella`…). |
| `parent` | `id` del cuerpo padre, o `null` si es raíz (como el Sol). |
| `radius` | Radio en km. |
| `mass` | Masa en kg. |
| `color` | Color CSS del cuerpo y de sus rastros. |
| `el` | Elementos keplerianos (obligatorio solo si `parent` no es `null`). |
| `P` | Periodo orbital en días. |
| `gm` | Parámetro gravitacional estándar en m³/s² (para velocidad y aceleración). |

### Consejos para cuerpos nuevos

- **Cinturón de asteroides**: puedes generar decenas de asteroides con `a` entre 2.2 y 3.2 UA, `e` entre 0.05 y 0.25, `i` entre 0° y 20°, y valores aleatorios de `Ω`, `ϖ`, `L`. El motor los trata igual que a cualquier otro cuerpo.
- **Cometas**: usa `e` alto (0.7–0.99) e `i` grande (hasta 90°+) para verlos salir del plano.
- **Cuerpos del cinturón de Kuiper**: `a > 30 UA`. Ajusta el preset "Sistema completo" si quieres verlos en el encuadre inicial.
- **Cuerpos con `e = 0`, `i = 0`, `Ω = 0`, `ϖ = 0`** producen órbitas circulares perfectas — útiles para lunas simplificadas.

---

## 🗺 Roadmap

- [x] Planetas del Sistema Solar con elementos J2000 reales.
- [x] Principales lunas de Marte, Júpiter, Saturno, Urano y Neptuno.
- [x] Rastros, panel de datos, zoom profundo, inclinación de vista.
- [ ] **Cinturón de asteroides** (grupo de cuerpos con órbitas distribuidas).
- [ ] **Cinturón de Kuiper** y planetas enanos (Ceres, Plutón, Eris, Makemake, Haumea).
- [ ] **Cometas** con alta excentricidad e inclinación.
- [ ] **Anillos de Saturno** (y de Urano / Neptuno) como geometría dedicada.
- [ ] **Texturas** opcionales por planeta (modo alternativo al color plano).
- [ ] **Búsqueda** de cuerpos por nombre.
- [ ] **Persistencia** del estado de cámara y selección en `localStorage`.
- [ ] **Modo efemérides**: introducir una fecha y saltar a ella.

---

## ⚠️ Limitaciones conocidas

- **Lunas simplificadas**: los elementos orbitales de los satélites son aproximados (valores promedio). No se modelan perturbaciones, resonancias ni precesión. Para visualización general es suficiente, pero no para astronomía de precisión.
- **Escala de tamaños exagerada por defecto**: el Sol y los planetas pequeños (Mercurio, Marte) necesitan un mínimo en píxeles para ser visibles a escala de sistema completo. El HUD indica cuándo se aplica exageración. El botón **Escala real** la desactiva.
- **Escala de distancias comprimible por zoom**: con zoom extremo en la Tierra–Luna, las distancias entre planetas se vuelven inabarcables en pantalla. Es el compromiso habitual de los simuladores 2D/3D.
- **Cálculo en CPU con Canvas 2D**: apto para decenas de cuerpos; no está optimizado para miles de asteroides simultáneos. Si en el futuro se añade un cinturón completo, conviene migrar el render a WebGL o agrupar cuerpos en *sprites*.
- **Sin física N-cuerpos**: cada cuerpo sigue su órbita kepleriana alrededor de su padre sin influencia de otros. Es intencional (rendimiento y estabilidad), pero no sirve para estudiar caos orbital.

---

## 🤝 Contribuir

Este proyecto es software libre bajo GPL v3 y **todas las contribuciones son bienvenidas**. Puedes:

1. Hacer *fork* del repositorio.
2. Crear una rama para tu cambio: `git checkout -b feature/cinturon-asteroides`
3. Hacer commit de tus cambios: `git commit -m "Añade cinturón de asteroides"`
4. Hacer push a la rama: `git push origin feature/cinturon-asteroides`
5. Abrir un *pull request* describiendo el cambio.

### Buenas prácticas

- Mantén el estilo del código existente (comentarios numerados por sección).
- Si añades cuerpos al `CATALOG`, documenta la fuente de los elementos orbitales.
- Si modificas el motor, actualiza esta documentación (`README.md`).
- Al ser GPL v3, tus contribuciones se integrarán bajo la misma licencia.

### Ideas especialmente buscadas

- Catálogo completo de asteroides del cinturón principal.
- Modelo de anillos para Saturno.
- Cálculo opcional de perturbaciones de Júpiter sobre los asteroides.
- Migración del render a WebGL para miles de cuerpos.

---

## 📚 Referencias

- **Elementos orbitales planetarios (J2000)**: NASA JPL, *Approximate Positions of the Planets* — <https://ssd.jpl.nasa.gov/planets/approx_pos.html>
- **Datos físicos de planetas y lunas**: NASA Planetary Fact Sheet — <https://nssdc.gsfc.nasa.gov/planetary/factsheet/>
- **Parámetros gravitacionales estándar (GM)**: IAU 2015 Resolution B3.
- **Ecuación de Kepler y órbitas elípticas**: cualquier texto de mecánica celeste (p. ej. Vallado, *Fundamentals of Astrodynamics*).

---

## 📄 Licencia

**Simulador del Sistema Solar**

Copyright (C) 2024 Los autores del Simulador del Sistema Solar

Este programa es **software libre**: puedes redistribuirlo y/o modificarlo bajo los términos de la **GNU General Public License** tal como la publica la Free Software Foundation, ya sea la **versión 3** de la Licencia, o (a tu elección) cualquier versión posterior.

Este programa se distribuye con la esperanza de que sea útil, pero **SIN NINGUNA GARANTÍA**; ni siquiera la garantía implícita de **COMERCIABILIDAD** o **IDONEIDAD PARA UN PROPÓSITO PARTICULAR**. Consulta la GNU General Public License para más detalles.

Deberías haber recibido una copia de la GNU General Public License junto con este programa. Si no es así, consulta <https://www.gnu.org/licenses/>.

### Resumen de la licencia

| | |
|---|---|
| **Licencia** | GNU General Public License v3.0 |
| **SPDX** | `GPL-3.0-or-later` |
| **Copyright** | (C) 2024 Los autores del Simulador del Sistema Solar |
| **Texto legal completo** | [LICENSE](./LICENSE) · [gnu.org/licenses/gpl-3.0](https://www.gnu.org/licenses/gpl-3.0.txt) |

> ⚠️ **Importante**: para que el proyecto esté correctamente licenciado bajo GPL v3, además de este `README.md` debes incluir en la raíz del repositorio un archivo llamado `LICENSE` (sin extensión) con el texto legal completo de la GNU GPL v3. Puedes obtenerlo en:
>
> - <https://www.gnu.org/licenses/gpl-3.0.txt>
> - <https://choosealicense.com/licenses/gpl-3.0/>

### Qué implica la GPL v3 (resumen no legal)

- ✅ Puedes **usar** el programa para cualquier propósito.
- ✅ Puedes **estudiar** y **modificar** el código fuente.
- ✅ Puedes **redistribuir** copias.
- ✅ Puedes **distribuir versiones modificadas**.
- ⚠️ Si redistribuyes el programa (original o modificado), **debes hacerlo bajo la misma licencia GPL v3** y **entregar el código fuente**.
- ⚠️ **No se ofrece ninguna garantía** al usuario.
- ⚠️ **No se puede relicenciar** a una licencia más restrictiva (copyleft fuerte).

---

## 🙌 Agradecimientos

Inspirado en la larga tradición de simuladores orbitales abiertos (NASA Eyes on the Solar System, Solar System Scope, Orbit Simulator de PhET) y construido con la idea de que **cualquier persona pueda extenderlo añadiendo una línea al catálogo**.

> *"El Sistema Solar no es un lugar, es un proceso."* — Carl Sagan (paráfrasis)

---

**Hecho con ❤️ y con libertad — GPL v3 garantiza que seguirá siendo libre.**