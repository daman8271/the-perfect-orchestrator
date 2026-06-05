# Security model

The Perfect Orchestrator spawns **autonomous** Claude Code sessions with a permissive
allowlist. That's the point of it — and it deserves clear eyes.

## What workers can do

Workers run with `defaultMode: auto`, `skipAutoPermissionPrompt: true`, and the
allowlist in [config/worker-settings.json](config/worker-settings.json): git, gh,
node/npm, python/pip, file reads/edits/writes, grep/find, `curl`/`wget`, `chmod`.
A worker can therefore modify files in its workdir, run code, commit, and reach the
network **without asking anyone**.

## Deliberate guardrails

- **`rm` is not allowlisted.** Destructive deletes still pass through Claude Code's
  permission classifier instead of running blind. Keep it that way.
- **Isolated config dir.** Workers get their own `CLAUDE_CONFIG_DIR` — your hooks,
  history, memory, and settings are never loaded or touched. Only credentials are
  shared (read-only symlink that follows rotation).
- **Workers don't push.** The recommended workflow (see
  [docs/PATTERNS.md](docs/PATTERNS.md)) has workers commit locally behind a lock;
  only the lead pushes, after reviewing each commit.

## Recommendations

1. **Run fleets on a VPS or in a container** — not on a workstation with access to
   things you'd miss.
2. Point fleets at **git-controlled directories** you can `git reset --hard`.
3. Don't put production secrets in a fleet workdir; workers can `cat` anything in it.
4. Review the allowlist before first use and remove anything your work doesn't need
   (`~/.orch/worker-config/settings.json` after first run).
5. Size fleets to your plan — a rate-limited fleet mid-task is a half-finished
   autonomous change set.

## Reporting a vulnerability

Open a GitHub issue (or a private security advisory) on this repository. Please
include reproduction steps. Reports are welcome and credited.
