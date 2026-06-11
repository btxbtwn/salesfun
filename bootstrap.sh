#!/usr/bin/env bash
set -euo pipefail

# ── Salesfun Bootstrap ── One-command setup for DelRicht Salesforce menu ──
# Run: curl -fsSL https://raw.githubusercontent.com/btxbtwn/opencode-vision-mcp/main/scripts/salesfun-bootstrap.sh | bash

BOLD="\033[1m"
GREEN="\033[38;5;2m"
YELLOW="\033[38;5;3m"
RED="\033[38;5;1m"
BLUE="\033[38;5;117m"
DIM="\033[2m"
RESET="\033[0m"

echo
echo -e "${BLUE}${BOLD}  s a l e s f u n  —  Bootstrap${RESET}"
echo
echo -e "${DIM}  One command. No admin password. No training.${RESET}"
echo

# ── Ensure ~/.local/bin exists and is on PATH ──
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

# ── 1. Install GitHub CLI (no admin/sudo) ──
if command -v gh &>/dev/null; then
    echo -e "  ${GREEN}GitHub CLI found${RESET}"
else
    echo -e "  ${YELLOW}Installing GitHub CLI (no admin needed)...${RESET}"
    ARCH=$(uname -m | sed 's/x86_64/amd64/;s/arm64/arm64/')
    VER=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | grep '"tag_name"' | head -1 | sed 's/.*"v\([^"]*\)".*/\1/')
    curl -fsSL "https://github.com/cli/cli/releases/download/v${VER}/gh_${VER}_macOS_${ARCH}.zip" -o /tmp/gh-setup.zip
    unzip -o /tmp/gh-setup.zip -d /tmp > /dev/null
    cp /tmp/gh_*_macOS_*/bin/gh "$HOME/.local/bin/gh"
    rm -rf /tmp/gh-setup.zip /tmp/gh_*_macOS_*
    if command -v gh &>/dev/null; then
        echo -e "  ${GREEN}GitHub CLI installed${RESET}"
    else
        echo -e "  ${RED}GitHub CLI install failed. Download from https://cli.github.com${RESET}"
        exit 1
    fi
fi

# ── 2. Authenticate to GitHub ──
if gh auth status &>/dev/null 2>&1; then
    echo -e "  ${GREEN}GitHub authenticated${RESET}"
else
    echo -e "  ${YELLOW}Opening browser for GitHub login...${RESET}"
    gh auth login --hostname github.com --git-protocol https --web
    echo -e "  ${GREEN}Authenticated${RESET}"
fi

# ── 3. Clone the Salesforce ops repo ──
REPO_DIR="$HOME/delricht-salesforce-ops"
if [ -d "$REPO_DIR" ]; then
    echo -e "  ${GREEN}Repo already cloned${RESET}"
else
    echo -e "  ${YELLOW}Cloning delricht-salesforce-ops...${RESET}"
    gh repo clone btxbtwn/delricht-salesforce-ops "$REPO_DIR"
    echo -e "  ${GREEN}Cloned${RESET}"
fi

# ── 4. Run the full setup ──
echo
echo -e "  ${DIM}Running setup...${RESET}"
bash "$REPO_DIR/scripts/salesfun-setup"
