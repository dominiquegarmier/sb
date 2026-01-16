#!/bin/bash
set -e

REPO_URL="https://raw.githubusercontent.com/dominiquegarmier/sb/main"
INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/sb"

mkdir -p "$INSTALL_DIR" "$CONFIG_DIR"

# Download sb script
echo "Downloading sb..."
curl -fsSL "$REPO_URL/sb" -o "$INSTALL_DIR/sb"
chmod +x "$INSTALL_DIR/sb"

# Download Dockerfile for local builds
echo "Downloading Dockerfile..."
curl -fsSL "$REPO_URL/Dockerfile" -o "$CONFIG_DIR/Dockerfile"

# Create config template
CONFIG_FILE="${CONFIG_DIR}/config"
if [[ ! -f "$CONFIG_FILE" ]]; then
    cat > "$CONFIG_FILE" << 'EOF'
# sb configuration

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

if ! command -v mutagen &> /dev/null; then
    echo "Note: Mutagen is required for sb to work."
    echo "Install with:"
    echo "  macOS:  brew install mutagen-io/mutagen/mutagen"
    echo "  Linux:  https://mutagen.io/documentation/introduction/installation"
    echo ""
fi

echo "Installed sb to $INSTALL_DIR/sb"
