#!/bin/bash
set -e

REPO_URL="https://raw.githubusercontent.com/dominiquegarmier/ralph/main"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/ralph"

mkdir -p "$INSTALL_DIR" "$CONFIG_DIR"

# Download ralph script
echo "Downloading ralph..."
curl -fsSL "$REPO_URL/ralph" -o "$INSTALL_DIR/ralph"
chmod +x "$INSTALL_DIR/ralph"

# Download Dockerfile for local builds
echo "Downloading Dockerfile..."
curl -fsSL "$REPO_URL/Dockerfile" -o "$CONFIG_DIR/Dockerfile"

# Create config template
CONFIG_FILE="${CONFIG_DIR}/config"
if [[ ! -f "$CONFIG_FILE" ]]; then
    cat > "$CONFIG_FILE" << 'EOF'
# ralph configuration

# GitHub token for gh CLI (recommend read-only PAT)
#GH_TOKEN="ghp_xxxxxxxxxxxx"
EOF
fi

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
        zsh)  PROFILE="~/.zshrc" ;;
        bash) PROFILE="~/.bashrc" ;;
        *)    PROFILE="your shell profile" ;;
    esac
    echo "Add this to $PROFILE:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

echo "Installed ralph to $INSTALL_DIR/ralph"
