# box

Containerized dev environment with Claude Code, Codex, and Python venv isolation.

## Prerequisites

- Docker

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/dominiquegarmier/box/main/install.sh | bash
```

This downloads:
- `box` script to `~/.local/bin/`
- `Dockerfile` to `~/.config/box/`
- Config template to `~/.config/box/config`

## Usage

```bash
box                                       # interactive bash shell
box -- [cmd]                              # run command in container
box -- claude --dangerously-skip-permissions
box -- codex --full-auto
box -- python script.py
box -- uv sync                            # install deps (venv at /venv/project)
```

### Flags

```bash
box --rm                      # ephemeral (remove container on exit)
box --forward-docker          # mount docker socket into container
box --rebuild                 # nuke everything and rebuild image from scratch
box --rm -- python script.py  # combine flags with command
```

## Configuration

Edit `~/.config/box/config`:

```bash
# GitHub token for gh CLI (recommend read-only PAT)
GH_TOKEN="ghp_xxxxxxxxxxxx"
```

## What's Included

- Ubuntu latest
- Python 3 + uv
- Node.js 22
- Claude Code + Codex
- gh CLI, git, vim, ripgrep, fd, jq, htop, tree
- Docker CLI (for --forward-docker)

## How It Works

1. **First run**: Builds Docker image locally from `~/.config/box/Dockerfile`
2. **Per-project**: Creates container keyed by absolute path hash
3. **File access**: Bind mounts your repo at `/work` (immediate, no sync)
4. **Python venv**: `UV_PROJECT_ENVIRONMENT=/venv/{project}` keeps venvs in the container (not in repo)
5. **State persists**: Container and venvs persist across sessions

### Why Bind Mount + Container Venv?

- **Code edits** are immediate via bind mount
- **Python installs** (`uv sync`) go to container filesystem at `/venv/` (fast, no macOS overhead)
- No `.venv/` cluttering your repo
- Venvs persist as long as the container does

## Auth

- **Claude**: `~/.claude/` mounted from host
- **Codex**: `~/.codex/` mounted from host
- **GitHub**: `GH_TOKEN` from config file

## Update

Re-run install to get latest Dockerfile, then rebuild:

```bash
curl -fsSL https://raw.githubusercontent.com/dominiquegarmier/box/main/install.sh | bash
box --rebuild
```

**Note:** `--rebuild` deletes all container state (installed packages, image cache).
