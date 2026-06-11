#!/usr/bin/env bash
set -euo pipefail

# ── Salesfun Bootstrap ── One curl, done ─────────────────
# curl -fsSL https://raw.githubusercontent.com/btxbtwn/salesfun/main/bootstrap.sh | bash

BOLD="\033[1m"
GREEN="\033[38;5;2m"
YELLOW="\033[38;5;3m"
RED="\033[38;5;1m"
BLUE="\033[38;5;117m"
DIM="\033[2m"
RESET="\033[0m"

echo
echo -e "${BLUE}${BOLD}  s a l e s f u n${RESET}"
echo -e "  ${DIM}DelRicht Salesforce Menu — One-Command Setup${RESET}"
echo

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

# 1. GitHub CLI
if command -v gh &>/dev/null; then
    echo -e "  ${GREEN}✓${RESET} GitHub CLI"
else
    echo -e "  ${YELLOW}Installing GitHub CLI...${RESET}"
    ARCH=$(uname -m | sed 's/x86_64/amd64/;s/arm64/arm64/')
    VER=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | grep '"tag_name"' | head -1 | sed 's/.*"v\([^"]*\)".*/\1/')
    curl -fsSL "https://github.com/cli/cli/releases/download/v${VER}/gh_${VER}_macOS_${ARCH}.zip" -o /tmp/gh.zip
    unzip -o /tmp/gh.zip -d /tmp > /dev/null
    cp /tmp/gh_*_macOS_*/bin/gh "$HOME/.local/bin/gh"
    rm -rf /tmp/gh.zip /tmp/gh_*_macOS_*
    echo -e "  ${GREEN}✓${RESET} GitHub CLI installed"
fi

# 2. Auth
if gh auth status &>/dev/null 2>&1; then
    echo -e "  ${GREEN}✓${RESET} GitHub authenticated"
else
    echo -e "  ${YELLOW}Sign into GitHub in the browser window...${RESET}"
    gh auth login --hostname github.com --git-protocol https --web
    echo -e "  ${GREEN}✓${RESET} Authenticated"
fi

# 3. Clone
REPO_DIR="$HOME/delricht-salesforce-ops"
if [ -d "$REPO_DIR" ]; then
    echo -e "  ${GREEN}✓${RESET} Repo already cloned"
else
    echo -e "  ${YELLOW}Cloning delricht-salesforce-ops...${RESET}"
    gh repo clone btxbtwn/delricht-salesforce-ops "$REPO_DIR"
    echo -e "  ${GREEN}✓${RESET} Cloned"
fi

# 4. Run setup
echo
bash "$REPO_DIR/scripts/salesfun-setup"
