#!/usr/bin/env bash
# The Perfect Orchestrator — installer.
#   ./install.sh            install the `orch` CLI + the /orch Claude Code skill
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
SKILL_DIR="$HOME/.claude/skills/orch"

echo "The Perfect Orchestrator — installing"

command -v tmux >/dev/null 2>&1 || { echo "ERROR: tmux is required (apt install tmux / brew install tmux)"; exit 1; }
command -v claude >/dev/null 2>&1 || { echo "ERROR: Claude Code CLI is required: https://claude.com/claude-code"; exit 1; }

# 1. CLI on PATH
mkdir -p "$BIN_DIR"
ln -sf "$REPO_DIR/bin/orch" "$BIN_DIR/orch"
chmod +x "$REPO_DIR/bin/orch"
echo "  [ok] orch -> $BIN_DIR/orch"

# 2. Claude Code skill (gives your lead session the /orch playbook)
mkdir -p "$SKILL_DIR"
cp "$REPO_DIR/skill/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "  [ok] skill -> $SKILL_DIR"

# 3. PATH sanity
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "  [warn] $BIN_DIR is not on your PATH — add:  export PATH=\"\$PATH:$BIN_DIR\"" ;;
esac

echo
echo "Done. Next steps:"
echo "  1. orch doctor            # verify setup + see the allow-rules your LEAD needs"
echo "  2. open Claude Code and type /orch to put your session in command of a fleet"
