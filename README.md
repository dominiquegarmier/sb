# sb - Sandbox

Containerized dev environment with Claude Code, Codex, and Mutagen file sync.

## Prerequisites

- Docker
- Mutagen: `brew install mutagen-io/mutagen/mutagen`

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/dominiquegarmier/sb/main/install.sh | bash
```

This downloads:
- `sb` script to `~/.local/bin/`
- `Dockerfile` to `~/.config/sb/`
- Config template to `~/.config/sb/config`

## Usage

```bash
sb                                          # interactive bash shell
sb -- [cmd]                                 # run command in container
sb -- claude --dangerously-skip-permissions
sb -- codex --full-auto
sb -- python script.py
```

### Flags

```bash
sb --rm                      # ephemeral (remove container on exit)
sb --forward-docker          # mount docker socket into container
sb --rebuild                 # nuke everything and rebuild image from scratch
sb --rm -- python script.py  # combine flags with command
```

## Configuration

Edit `~/.config/sb/config`:

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

1. **First run**: Builds Docker image locally from `~/.config/sb/Dockerfile`
2. **Per-project**: Creates container + volume keyed by absolute path hash
3. **File sync**: Mutagen syncs files bidirectionally, excluding platform artifacts
4. **State persists**: Container state (apt packages, etc.) persists across sessions

## Ignores

Patterns from `.gitignore` files are automatically used:
- Global gitignore (`core.excludesFile`)
- Project `.gitignore` files (including nested ones)

If no `.gitignore` exists, these defaults are used:
`.venv`, `__pycache__`, `*.pyc`, `node_modules`, `target`, `build`

## Auth

- **Claude**: `~/.claude/` mounted from host
- **Codex**: `~/.codex/` mounted from host
- **GitHub**: `GH_TOKEN` from config file

## Update

Re-run install to get latest Dockerfile, then rebuild:

```bash
curl -fsSL https://raw.githubusercontent.com/dominiquegarmier/sb/main/install.sh | bash
sb --rebuild
```

**Note:** `--rebuild` deletes all container state (installed packages, volumes).
