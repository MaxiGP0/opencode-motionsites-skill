#!/usr/bin/env bash
# Install the free MotionSites Web Builder skill for OpenCode.
#
# Downloads the skill from the official Motionsites-AI/claude-skill repository
# and copies it to the OpenCode global skills directory, so OpenCode discovers
# it automatically. Nothing is vendored or re-hosted by this project.

set -euo pipefail

REPO="Motionsites-AI/claude-skill"
NAME="motionsites-web-builder"
REF="${MOTIONSITES_REF:-main}"
SKILLS_DIR="${OPENCODE_SKILLS_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills}"
FORCE=0
if [[ "${MOTIONSITES_FORCE:-0}" == "1" ]]; then
    FORCE=1
fi

usage() {
    cat <<EOF
Usage: install.sh [options]

Options:
  --dir PATH    OpenCode skills root (default: ~/.config/opencode/skills)
  --ref REF     Branch, tag, or commit of the upstream repo (default: main)
  --force       Replace an existing installation
  -h, --help    Show this help

Environment:
  OPENCODE_SKILLS_DIR   Same as --dir
  MOTIONSITES_REF       Same as --ref
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dir)
            [[ $# -ge 2 ]] || { echo "Missing value for --dir" >&2; exit 1; }
            SKILLS_DIR="$2"
            shift 2
            ;;
        --ref)
            [[ $# -ge 2 ]] || { echo "Missing value for --ref" >&2; exit 1; }
            REF="$2"
            shift 2
            ;;
        --force)
            FORCE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

for cmd in curl tar; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' is required but was not found in PATH." >&2
        exit 1
    fi
done

TARGET="$SKILLS_DIR/$NAME"
if [[ "$(basename "$TARGET")" != "$NAME" ]]; then
    echo "Refusing to install to an unexpected path: $TARGET" >&2
    exit 1
fi

if [[ -d "$TARGET" ]]; then
    if [[ "$FORCE" -ne 1 ]]; then
        echo "!!  $NAME is already installed at:"
        echo "    $TARGET"
        echo "    Re-run with --force to update it."
        exit 0
    fi
    echo "==> Removing the existing installation"
    rm -rf -- "$TARGET"
fi

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/motionsites.XXXXXX")"
cleanup() {
    rm -rf -- "$TMP_DIR"
}
trap cleanup EXIT

URL="https://github.com/$REPO/archive/$REF.tar.gz"
ARCHIVE="$TMP_DIR/skill.tar.gz"

echo "==> Downloading $URL"
curl -fsSL "$URL" -o "$ARCHIVE"

echo "==> Extracting"
tar -xzf "$ARCHIVE" -C "$TMP_DIR"

SKILL_MD="$(find "$TMP_DIR" -type f -path "*/$NAME/SKILL.md" -print -quit)"
if [[ -z "$SKILL_MD" ]]; then
    echo "Error: could not find $NAME/SKILL.md in the downloaded archive." >&2
    echo "The upstream layout may have changed." >&2
    exit 1
fi

if ! grep -Eq "^name:[[:space:]]*$NAME[[:space:]]*$" "$SKILL_MD"; then
    echo "Error: SKILL.md does not look like the MotionSites skill." >&2
    exit 1
fi

SOURCE_DIR="$(dirname "$SKILL_MD")"

echo "==> Installing to $TARGET"
mkdir -p -- "$SKILLS_DIR" "$TARGET"
cp -R -- "$SOURCE_DIR"/. "$TARGET"/

for required in \
    "SKILL.md" \
    "examples/INDEX.md" \
    "media/MEDIA.md" \
    "references/techniques/INDEX.md" \
    "scripts/shoot.py"
do
    if [[ ! -f "$TARGET/$required" ]]; then
        echo "Error: installation is incomplete: missing $required." >&2
        exit 1
    fi
done

FILE_COUNT="$(find "$TARGET" -type f | wc -l | tr -d ' ')"
echo "OK  Installed $FILE_COUNT files to $TARGET"

cat <<EOF

Start a new OpenCode session and ask for a landing page, hero, portfolio or redesign.
The skill is picked up automatically. Examples:
  - "Build a cinematic hero for a luxury sleep-tracking ring."
  - "Hazme una landing para un estudio de arquitectura en Lisboa. Editorial y silenciosa."
  - "Write a Lovable prompt for a waitlist page for my AI travel app."

Source and license: https://github.com/$REPO
EOF
