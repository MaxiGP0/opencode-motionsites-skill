# opencode-motionsites-skill

[![CI](https://github.com/MaxiGP0/opencode-motionsites-skill/actions/workflows/ci.yml/badge.svg)](https://github.com/MaxiGP0/opencode-motionsites-skill/actions/workflows/ci.yml)

[English](README.md) | [Español](README.es.md)

Instalador de un solo comando que deja disponible en [OpenCode](https://opencode.ai) el skill gratuito **[MotionSites Web Builder](https://github.com/Motionsites-AI/claude-skill)**.

El skill original trae instrucciones para Claude.ai y Claude Code. OpenCode descubre los skills globales en `~/.config/opencode/skills/<nombre>/`, así que este repositorio agrega un instalador y un verificador para esa ruta. **Descarga el skill desde el repositorio oficial al instalar**; no lo reempaqueta ni modifica su contenido.

> Este es un instalador no oficial. No está afiliado a MotionSites.

## Qué hace el skill

MotionSites Web Builder hace que OpenCode construya landing pages cinematográficas y de nivel premio en lugar de layouts genéricos de IA. En vez de partir de una idea vaga, parte de un diseño real y terminado de MotionSites, reescribe el copy, adapta la paleta y los medios a tu marca, construye la página, toma una captura y corrige lo que está mal.

La muestra gratuita incluye:

- **16 diseños seleccionados** con prompts completos de construcción.
- **76 videos gratuitos de fondo para heroes**, descritos por clima, más recortes e imágenes.
- **Más de 55 recetas de técnicas** con código funcionando: glass líquido, loops de video sin cortes, titulares con blur palabra por palabra, carruseles con profundidad, historias al hacer scroll, Three.js y más.
- **Reglas de gusto con números reales** para tipografía, color, espaciado, movimiento y copy.
- **Un paso de mirar y corregir** con captura y checklist de QA.
- **Modo prompt** para Lovable, Bolt, v0, Cursor, Manus, Google AI Studio y Kimi.

## Requisitos

- [OpenCode](https://opencode.ai) con soporte de skills.
- **Windows:** PowerShell 5.1 o superior (viene con Windows 10/11).
- **macOS / Linux:** `bash`, `curl` y `tar`.
- **Opcional:** Python 3 y Playwright para el script de capturas del skill. Cualquier navegador o herramienta de vista previa también sirve.

## Instalación

### Windows (PowerShell)

Descargá, revisá y ejecutá:

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.ps1 -OutFile install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

O ejecutalo directamente:

```powershell
irm https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.ps1 | iex
```

Para actualizar:

```powershell
# Si guardaste install.ps1:
.\install.ps1 -Force

# O sin guardarlo:
$env:MOTIONSITES_FORCE=1; irm https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.ps1 | iex
```

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.sh | bash
```

Para actualizar:

```bash
curl -fsSL https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.sh | bash -s -- --force
```

Si preferís leer el script antes:

```bash
curl -fsSL https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.sh -o install.sh
bash install.sh
```

### Opciones

| PowerShell | Bash | Descripción |
| --- | --- | --- |
| `-SkillDir PATH` | `--dir PATH` | Raíz de skills de OpenCode. Por defecto: `~/.config/opencode/skills` |
| `-Ref REF` | `--ref REF` | Rama, tag o commit del repo original. Por defecto: `main` |
| `-Force` | `--force` | Reemplaza una instalación existente |

También funcionan las variables de entorno `OPENCODE_SKILLS_DIR`, `MOTIONSITES_REF` y `MOTIONSITES_FORCE=1`.

El skill se instala en:

- Windows: `%USERPROFILE%\.config\opencode\skills\motionsites-web-builder`
- macOS / Linux: `~/.config/opencode/skills/motionsites-web-builder`

## Verificar la instalación

```powershell
.\verify.ps1
```

```bash
bash verify.sh
```

O comprobá a mano:

```bash
ls ~/.config/opencode/skills/motionsites-web-builder/SKILL.md
```

Después de instalar, **abrí una sesión nueva de OpenCode** para que tome el skill.

## Cómo usarlo

Solo pedí un sitio. El skill se activa automáticamente:

- *"Build a landing page hero for a luxury sleep-tracking ring."*
- *"Hazme una landing para un estudio de arquitectura en Lisboa. Editorial y silenciosa."*
- *"Make a portfolio homepage for an architectural photographer. Quiet, editorial."*
- *"Write a Lovable prompt for a waitlist page for my AI travel app."*
- *"Here is my current site: make it look award-winning."*

El skill puede construir dentro de un proyecto React / Next / Vite existente, o producir un único `index.html` autocontenido que abre en cualquier lado.

## Opcional: que el skill vea su trabajo

El paso de mirar y corregir funciona mejor con Playwright:

```bash
pip install playwright
python -m playwright install chromium
```

Si no tenés Python ni Playwright, el skill usa cualquier navegador o herramienta de vista previa. En OpenCode, la extensión de navegador puede tomar las capturas.

## Instalación manual

Si preferís no ejecutar un instalador:

```bash
git clone --depth 1 https://github.com/Motionsites-AI/claude-skill.git
mkdir -p ~/.config/opencode/skills
cp -R claude-skill/plugins/motionsites-web-builder/skills/motionsites-web-builder ~/.config/opencode/skills/
```

En Windows, reemplazá `~/.config/opencode/skills` por `%USERPROFILE%\.config\opencode\skills`.

## Actualizar y desinstalar

Actualizá volviendo a ejecutar el instalador con `-Force` / `--force`. El instalador siempre baja la revisión actual del repo original, así que las actualizaciones llegan apenas se publican.

Desinstalar:

```powershell
Remove-Item -Recurse -Force "$HOME\.config\opencode\skills\motionsites-web-builder"
```

```bash
rm -rf ~/.config/opencode/skills/motionsites-web-builder
```

## Cómo funciona

1. Descarga el archivo del repositorio original (rama, tag o commit).
2. Lo extrae en un directorio temporal.
3. Busca `plugins/motionsites-web-builder/skills/motionsites-web-builder` y valida su `SKILL.md`.
4. Lo copia a la carpeta global de skills de OpenCode y revisa los archivos requeridos.

En este repositorio no se guarda una copia del skill: el instalador es un descargador fino más un verificador.

## Licencias y atribución

- **Este instalador:** MIT. Ver [LICENSE](LICENSE).
- **MotionSites Web Builder:** las instrucciones y el código son MIT; los prompts de ejemplo y los medios siguen siendo © MotionSites y pueden usarse en sitios construidos con el skill. Este repositorio no los redistribuye. Ver la [licencia original](https://github.com/Motionsites-AI/claude-skill/blob/main/LICENSE).
- **MotionSites:** los diseños, los medios y el nombre pertenecen a sus dueños. Este proyecto es no oficial y no está afiliado a MotionSites.

Si el skill te resulta útil, dale una estrella al repositorio original: [Motionsites-AI/claude-skill](https://github.com/Motionsites-AI/claude-skill).

## Solución de problemas

**El skill no aparece en OpenCode.** Confirmá la ruta con `verify.ps1` / `verify.sh` y abrí una sesión nueva. OpenCode lee la carpeta de skills al iniciar la sesión.

**PowerShell bloquea el script.** Usá `powershell -ExecutionPolicy Bypass -File .\install.ps1`.

**Falta `curl` en Linux.** Instalalo (`sudo apt install curl`, `sudo dnf install curl` o el equivalente de tu distribución).

**La descarga falla.** El instalador necesita acceso a `github.com` y `codeload.github.com`. Revisá el proxy o el firewall.

**No hay Python para las capturas.** Usá cualquier navegador o herramienta de vista previa; el skill lo permite explícitamente.
