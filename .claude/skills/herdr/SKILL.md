---
name: herdr
description: "Control Herdr, a terminal multiplexer for coding agents. Use only when the user explicitly mentions Herdr or explicitly asks to inspect or control its panes, tabs, workspaces, commands, or agents. Do not use merely because background or parallel work could help. Requires HERDR_ENV=1."
---

# Herdr

Use Herdr to inspect and control the current Herdr-managed terminal session. Keep
this an explicit-use tool: do not start Herdr or delegate through it unless the
user asked for Herdr or visible Herdr-based parallel work.

## Check the runtime

Before any control command, confirm this agent is inside Herdr:

```bash
test "${HERDR_ENV:-}" = 1
```

If this fails, explain that the current agent is not running inside Herdr and
stop. Do not control a focused Herdr session from outside it.

Use the installed CLI as the syntax authority:

```bash
herdr --help
herdr pane
herdr workspace
herdr worktree
herdr tab
herdr wait
```

Never run bare `herdr` for discovery because it launches or attaches the TUI.
Do not probe a mutating nested command without arguments. Read IDs and state
from JSON output; never construct IDs from examples or display order.

## Address the current session safely

Herdr provides stable context in managed panes:

```bash
printf '%s\n' "$HERDR_WORKSPACE_ID" "$HERDR_TAB_ID" "$HERDR_PANE_ID"
```

Prefer `--current` or an explicit returned ID. Omitting the target may select a
pane focused by the user or another client. Discover state with:

```bash
herdr workspace list
herdr tab list --workspace "$HERDR_WORKSPACE_ID"
herdr pane current --current
herdr pane list --workspace "$HERDR_WORKSPACE_ID"
```

Pane IDs are the control surface for agents, shells, tests, servers, and logs.
After creating, splitting, or moving a resource, use the ID in that command's
response; moved panes can receive a new ID.

## Delegate an agent

For read-only work, a sibling pane may share the current checkout. For any task
that edits repository files, first create a dedicated worktree:

```bash
herdr worktree create --branch NAME --base REF
```

Do not let a delegated editing agent switch branches in the user's checkout.

When the user did not request a different layout, inspect the current pane and
split right if wide, otherwise down. Preserve the user's focus:

```bash
herdr pane layout --pane "$HERDR_PANE_ID"
herdr pane split --current --direction right --no-focus
```

Read the returned pane ID, label it, and start the normal interactive agent:

```bash
herdr pane rename PANE_ID "reviewer"
herdr pane run PANE_ID "codex"
herdr pane get PANE_ID
herdr wait agent-status PANE_ID --status idle --timeout 30000
herdr pane run PANE_ID "Review the current diff and report actionable findings."
```

Use `claude` for Claude Code and `codex` for Codex. Start the interactive
executable first, then send the task with `pane run`; do not pass a prompt as
argv or add non-interactive flags unless requested.

Agent status is `idle`, `working`, `blocked`, `done`, or `unknown`. A completed
visible agent usually becomes `idle`; a completed unseen agent becomes `done`.
Treat either as completion after checking `pane get`.

```bash
herdr wait agent-status PANE_ID --status working --timeout 30000
herdr wait agent-status PANE_ID --status done --timeout 120000
herdr pane read PANE_ID --source recent-unwrapped --lines 120
```

If a wait times out, inspect `pane get` and `pane read` before acting. A blocked
agent needs input; an unknown pane may not yet contain a detected agent.

## Run and inspect commands

Run ordinary commands in panes by the same split-and-returned-ID workflow:

```bash
herdr pane run PANE_ID "just test"
herdr pane read PANE_ID --source recent-unwrapped --lines 120
herdr wait output PANE_ID --match "test result" --timeout 120000
```

Inspect existing output before waiting for future output. Prefer
`recent-unwrapped` for logs and transcripts, `visible` for the current viewport,
and `--format ansi` only when terminal styling is evidence.

## Safety

- Use `--no-focus` for background work unless the user asked to switch context.
- Do not close resources you did not create unless explicitly asked.
- Remove a worktree created for delegation after its result is integrated.
- Never run `herdr server stop` or kill the main Herdr process unless the user
  explicitly asks to stop the session and its pane processes.
