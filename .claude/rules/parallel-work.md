# Parallel work

- Do not use Herdr or start another coding agent unless the user explicitly asks
  for Herdr, delegation, or parallel agent work.
- Give every delegated editing task its own worktree. Never let a delegated
  agent switch branches or edit inside the user's active checkout.
- Read-only delegation may share the current checkout.
- Prefer Herdr when the user wants visible, persistent, or intervenable agent
  work and `HERDR_ENV=1`. Use native subagents for disposable hidden research.
- Remove worktrees created for completed delegation after integrating results.
