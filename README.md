# ralph

Containerized dev environment with Claude Code, Codex, and Python venv isolation.

## Prerequisites

- Docker

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/dominiquegarmier/ralph/main/install.sh | bash
```

This downloads:
- `ralph` script to `~/.local/bin/`
- `Dockerfile` to `~/.config/ralph/`
- Config template to `~/.config/ralph/config`

## Usage

```bash
ralph                                       # interactive bash shell
ralph -- [cmd]                              # run command in container
ralph -- claude --dangerously-skip-permissions
ralph -- codex --full-auto
ralph -- python script.py
ralph -- uv sync                            # install deps (venv at /venv/project)
```

### Flags

```bash
ralph --rm                      # ephemeral (remove container on exit)
ralph --forward-docker          # mount docker socket into container
ralph --rebuild                 # nuke everything and rebuild image from scratch
ralph --rm -- python script.py  # combine flags with command
```

## Configuration

Edit `~/.config/ralph/config`:

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

1. **First run**: Builds Docker image locally from `~/.config/ralph/Dockerfile`
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
curl -fsSL https://raw.githubusercontent.com/dominiquegarmier/ralph/main/install.sh | bash
ralph --rebuild
```

**Note:** `--rebuild` deletes all container state (installed packages, image cache).
