# opencode-motionsites-skill

[![CI](https://github.com/MaxiGP0/opencode-motionsites-skill/actions/workflows/ci.yml/badge.svg)](https://github.com/MaxiGP0/opencode-motionsites-skill/actions/workflows/ci.yml)

[English](README.md) | [Español](README.es.md)

One-command installer that makes the free **[MotionSites Web Builder](https://github.com/Motionsites-AI/claude-skill)** skill available in [OpenCode](https://opencode.ai).

The upstream skill ships with instructions for Claude.ai and Claude Code. OpenCode discovers global skills in `~/.config/opencode/skills/<name>/`, so this repository adds a small, dependency-free installer and verifier for that layout. It **downloads the skill from the official repository at install time**; it does not re-host or modify the skill's content.

> This is an unofficial installer. It is not affiliated with MotionSites.

## What the skill does

The MotionSites Web Builder skill makes OpenCode build cinematic, award-level landing pages instead of generic AI layouts. Instead of starting from a vague idea, it starts from a real, finished MotionSites design, then rewrites the copy, adapts the palette and media to your brand, builds the page, takes a screenshot, and fixes what is off.

The free sample includes:

- **16 hand-picked designs** with full build prompts.
- **76 free hero background videos** described by mood, plus cut-outs and images.
- **55+ technique recipes** with working code: liquid glass, seamless video loops, word-by-word blur headlines, depth carousels, scroll stories, Three.js, and more.
- **Taste rules with real numbers** for type, colour, spacing, motion, and copy.
- **A look-and-fix step** with a screenshot and QA checklist.
- **Prompt mode** for Lovable, Bolt, v0, Cursor, Manus, Google AI Studio, and Kimi.

## Requirements

- [OpenCode](https://opencode.ai) with skills support.
- **Windows:** PowerShell 5.1 or newer (built into Windows 10/11).
- **macOS / Linux:** `bash`, `curl`, and `tar`.
- **Optional:** Python 3 and Playwright for the skill's own screenshot script. Any browser or preview tool also works.

## Install

### Windows (PowerShell)

Download, inspect, and run:

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.ps1 -OutFile install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Or run it directly:

```powershell
irm https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.ps1 | iex
```

To update:

```powershell
# If you saved install.ps1:
.\install.ps1 -Force

# Or without saving it:
$env:MOTIONSITES_FORCE=1; irm https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.ps1 | iex
```

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.sh | bash
```

To update:

```bash
curl -fsSL https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.sh | bash -s -- --force
```

Read the script first if you prefer:

```bash
curl -fsSL https://raw.githubusercontent.com/MaxiGP0/opencode-motionsites-skill/main/install.sh -o install.sh
bash install.sh
```

### Options

| PowerShell | Bash | Description |
| --- | --- | --- |
| `-SkillDir PATH` | `--dir PATH` | OpenCode skills root. Default: `~/.config/opencode/skills` |
| `-Ref REF` | `--ref REF` | Branch, tag, or commit of the upstream repo. Default: `main` |
| `-Force` | `--force` | Replace an existing installation |

Environment variables `OPENCODE_SKILLS_DIR`, `MOTIONSITES_REF`, and `MOTIONSITES_FORCE=1` work too.

The skill is installed to:

- Windows: `%USERPROFILE%\.config\opencode\skills\motionsites-web-builder`
- macOS / Linux: `~/.config/opencode/skills/motionsites-web-builder`

## Verify the installation

```powershell
.\verify.ps1
```

```bash
bash verify.sh
```

Or check manually:

```bash
ls ~/.config/opencode/skills/motionsites-web-builder/SKILL.md
```

After installing, **start a new OpenCode session** so it picks up the skill.

## Use it

Just ask for a site. The skill triggers automatically:

- *"Build a landing page hero for a luxury sleep-tracking ring."*
- *"Hazme una landing para un estudio de arquitectura en Lisboa. Editorial y silenciosa."*
- *"Make a portfolio homepage for an architectural photographer. Quiet, editorial."*
- *"Write a Lovable prompt for a waitlist page for my AI travel app."*
- *"Here is my current site: make it look award-winning."*

The skill can build inside an existing React / Next / Vite project, or produce a single self-contained `index.html` that opens anywhere.

## Optional: let the skill see its work

The look-and-fix step works best with Playwright:

```bash
pip install playwright
python -m playwright install chromium
```

If you do not have Python or Playwright, the skill falls back to any browser or preview tool. In OpenCode, the browser extension can take the screenshots.

## Manual installation

If you prefer not to run an installer:

```bash
git clone --depth 1 https://github.com/Motionsites-AI/claude-skill.git
mkdir -p ~/.config/opencode/skills
cp -R claude-skill/plugins/motionsites-web-builder/skills/motionsites-web-builder ~/.config/opencode/skills/
```

On Windows, replace `~/.config/opencode/skills` with `%USERPROFILE%\.config\opencode\skills`.

## Update and uninstall

Update by re-running the installer with `-Force` / `--force`. The installer always fetches the current upstream revision, so updates arrive as soon as upstream publishes them.

Uninstall:

```powershell
Remove-Item -Recurse -Force "$HOME\.config\opencode\skills\motionsites-web-builder"
```

```bash
rm -rf ~/.config/opencode/skills/motionsites-web-builder
```

## How it works

1. Download the upstream repository archive (default branch, tag, or commit).
2. Extract it to a temporary directory.
3. Find `plugins/motionsites-web-builder/skills/motionsites-web-builder` and validate its `SKILL.md`.
4. Copy it into the OpenCode global skills folder and check the required files.

Nothing is vendored in this repository: the installer is a thin downloader plus a verifier.

## Licenses and attribution

- **This installer:** MIT. See [LICENSE](LICENSE).
- **MotionSites Web Builder:** instructions and code are MIT; the example prompts and media remain © MotionSites and may be used in sites built with the skill. This repository does not redistribute them. See the [upstream license](https://github.com/Motionsites-AI/claude-skill/blob/main/LICENSE).
- **MotionSites:** designs, media, and the name belong to their owners. This project is unofficial and not affiliated with MotionSites.

If you find the skill useful, star the original repository: [Motionsites-AI/claude-skill](https://github.com/Motionsites-AI/claude-skill).

## Troubleshooting

**The skill does not appear in OpenCode.** Confirm the path with `verify.ps1` / `verify.sh`, then start a new session. OpenCode reads the skills folder when a session starts.

**PowerShell blocks the script.** Use `powershell -ExecutionPolicy Bypass -File .\install.ps1`.

**`curl` is missing on Linux.** Install it (`sudo apt install curl`, `sudo dnf install curl`, or your distribution's equivalent).

**The download fails.** The installer needs access to `github.com` and `codeload.github.com`. Check your proxy or firewall.

**No Python for screenshots.** Use any browser or preview tool; the skill explicitly allows it.
