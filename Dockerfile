FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    ca-certificates \
    gnupg \
    sudo \
    vim \
    less \
    htop \
    tree \
    jq \
    ripgrep \
    fd-find \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (required for Claude Code)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for --forward-docker)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Install Claude Code and Codex globally
RUN npm install -g @anthropic-ai/claude-code @openai/codex

# Create venv directory for UV_PROJECT_ENVIRONMENT
RUN mkdir -p /venv

# Create global gitignore for Linux and macOS artifacts
RUN cat > /root/.gitignore << 'EOF'
# Linux
*~
.fuse_hidden*
.directory
.Trash-*
.nfs*

# macOS
.DS_Store
.AppleDouble
.LSOverride
Icon
._*
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk
*.icloud
EOF

# Configure git to use global gitignore
RUN git config --global core.excludesFile /root/.gitignore

# Set up workspace directory
WORKDIR /work

# Nice shell defaults
RUN echo 'alias ll="ls -la"' >> /root/.bashrc \
    && echo 'export PS1="\[\033[1;34m\]box\[\033[0m\]:\[\033[1;32m\]\w\[\033[0m\]$ "' >> /root/.bashrc

# Default command
CMD ["/bin/bash"]
