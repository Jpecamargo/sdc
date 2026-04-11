#!/usr/bin/env bash
set -e

DEST="$HOME/.claude"

echo "Uninstalling SDC..."

rm -f "$DEST/commands/sdc.help.md"
rm -f "$DEST/commands/sdc.init.md"
rm -f "$DEST/commands/sdc.clarify.md"
rm -f "$DEST/commands/sdc.upgrade.md"
rm -rf "$DEST/sdc-templates"

echo "SDC uninstalled."
