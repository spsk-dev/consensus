#!/usr/bin/env bash
set -euo pipefail

# SpSk Consensus — Manual Installer
# For users who prefer manual installation over `claude /install-plugin`

REPO="spsk-dev/consensus"
INSTALL_DIR="${HOME}/.claude/plugins/consensus"

echo " SpSk consensus installer"
echo ""

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
  echo "Updating existing installation..."
  cd "$INSTALL_DIR"
  git pull origin main
else
  echo "Installing to $INSTALL_DIR..."
  git clone "https://github.com/${REPO}.git" "$INSTALL_DIR"
fi

echo ""
echo "Installed. Run /consensus in Claude Code to validate any conclusion."
echo ""
echo "Usage:"
echo '  /consensus "Your conclusion here"'
echo '  /consensus --evidence @analysis.md "The root cause is X"'
echo '  /consensus --domain architecture "Microservices is the right call"'
