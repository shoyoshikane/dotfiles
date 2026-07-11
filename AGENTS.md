# Agent Guide

This repository is macOS dotfiles managed mainly with Nix.
These shared rules are intended for both Claude Code and Codex.

## Shared conventions

- Keep changes minimal and scoped to the affected files
- Prefer explicit evidence over assumptions
- Treat generated or bulky files as derived unless proven otherwise
- Narrow the reading scope before editing
- Use the smallest workflow surface that fits the task

## Where to start

- Nix entrypoint: `.config/nix/flake.nix`
- Host-specific Nix config: `.config/nix/hosts/*/default.nix`
- Shared Nix modules: `.config/nix/home-manager/*.nix`
- Neovim: `.config/nvim/init.lua`, `.config/nvim/lua/config/*`, `.config/nvim/lua/plugins/*`
- zsh: `.config/zsh/rc/*`
- Single-file app configs: `.config/wezterm/wezterm.lua`, `.config/starship.toml`, `.config/aerospace/aerospace.toml`

## Shared working rules

- Read `.claude/rules/*` for path-scoped rules before editing
- Treat `.config/nix/flake.lock`, `.config/nvim/lazy-lock.json`, `.config/karabiner/**`, and `.config/vscode/**` as generated or heavy unless you need to edit them directly
- Prefer reusable skills over one-off long prompts
- The repo keeps reusable skills in `.claude/skills/`
- Codex uses the same skill content via `~/.codex/skills`

## Common tasks

- Commit workflow: `.claude/skills/git-commit/SKILL.md`
- Nix edits and validation: `.claude/skills/nix-edit/SKILL.md`
- Neovim edits: `.claude/skills/nvim-edit/SKILL.md`
- Shell and terminal edits: `.claude/skills/shell-edit/SKILL.md`
