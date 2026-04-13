#!/usr/bin/env bash
set -e

# Update this after publishing to GitHub
REPO="https://raw.githubusercontent.com/Jpecamargo/sdc/main"

DEST="$HOME/.claude"
COMMANDS_DIR="$DEST/commands"
TEMPLATES_DIR="$DEST/sdc-templates"

GREEN='\033[0;32m'
NC='\033[0m'

mkdir -p "$COMMANDS_DIR"
mkdir -p "$TEMPLATES_DIR/agents"
mkdir -p "$TEMPLATES_DIR/commands"
mkdir -p "$TEMPLATES_DIR/specs"

# Detect local vs remote install
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""
if [ -d "$SCRIPT_DIR/commands" ] && [ -d "$SCRIPT_DIR/templates" ]; then
  LOCAL=true
else
  LOCAL=false
fi

download() {
  local src="$1" dest="$2"
  if [ "$LOCAL" = true ]; then
    cp "$SCRIPT_DIR/$src" "$dest"
  else
    curl -fsSL "$REPO/$src" -o "$dest"
  fi
}

echo "Installing SDC..."

# Plugin commands
download "commands/sdc.help.md"    "$COMMANDS_DIR/sdc.help.md"
download "commands/sdc.init.md"    "$COMMANDS_DIR/sdc.init.md"
download "commands/sdc.clarify.md" "$COMMANDS_DIR/sdc.clarify.md"
download "commands/sdc.upgrade.md" "$COMMANDS_DIR/sdc.upgrade.md"

# Agent templates
for agent in architect tdd design docs \
             backend-nestjs backend-express backend-fastapi backend-django backend-rails \
             frontend-nextjs frontend-react-vite frontend-angular frontend-vue; do
  download "templates/agents/${agent}.md" "$TEMPLATES_DIR/agents/${agent}.md"
done

# Command templates
for cmd in orchestrate clarify commit test refine pr; do
  download "templates/commands/${cmd}.md" "$TEMPLATES_DIR/commands/${cmd}.md"
done

# Spec template
download "templates/specs/_template.md" "$TEMPLATES_DIR/specs/_template.md"

echo ""
echo -e "${GREEN}SDC installed.${NC}"
echo ""
echo "Available commands (use inside any Claude Code session):"
echo "  /sdc.init     — initialize a project with agents and skills"
echo "  /sdc.clarify  — clarify a feature before writing a spec"
echo "  /sdc.upgrade  — upgrade agents/commands to latest templates"
echo "  /sdc.help     — show full workflow and reference"
echo ""
echo "To get started: open Claude Code in a project and run /sdc.init"
