---
name: orch
description: Spawn and orchestrate a fleet of autonomous Claude Code workers in tmux. One LEAD Claude (you) spawns N worker sessions, hands each a task brief, coordinates them via a shared message bus, monitors them live, intervenes when they drift, and adversarially verifies results before reporting. Use for parallelizable, multi-target, long-running work (audits, fixes across many modules/platforms, broad sweeps, "do X across all N of these"). Triggers: "spawn a fleet", "orchestrate workers", "delegate this across sessions", "tmux Claude team", "divide this and run it in parallel".
---

<!-- COPY — canonical source: skill/SKILL.md at the repo root. Edit there, then re-sync this file (must be identical apart from this comment block: `diff skill/SKILL.md <(sed '5,6d' plugins/orchestrator/skills/orch/SKILL.md)` empty). -->

# The Perfect Orchestrator — lead playbook

You are the **LEAD**. This harness lets you spawn N autonomous Claude Code workers
(each its own tmux pane), brief each one, watch them, correct them, verify their
results, and drive them to completion — all from this one session. The CLI is `orch`
(run `orch --help` for usage; state lives under `$ORCH_HOME`, default `~/.orch`).

## The harness commands
| command | what it does |
|---|---|
| `orch spawn <session> <N> [workdir]` | Create tmux session `orch-<session>` with N worker panes + a shared workspace at `$ORCH_HOME/runs/<session>/shared/` (contains `bus.md`; `panes.txt` lives one level up). Workers are numbered 1..N. Workdir defaults to the current directory. |
| `orch send <session> <#> --file <path>` | Dispatch a task: tells worker # "Read and follow `<path>` then begin, work autonomously." |
| `orch send <session> <#> <one-line msg>` | Send a short single-line nudge (NO newlines — newline submits). |
| `orch read <session> <#> [lines]` | Capture a worker's pane (to see what it's doing). |
| `orch status [session]` | Overview of all live fleets, or one fleet's panes + done-flags + bus tail. |
| `orch kill <session>` | Tear down a fleet when done. |

Workers launch with an **isolated config** (no hooks → no notification spam on every
turn, a generous allowlist → no permission prompts, shared live credentials,
`ORCH_WORKER=1`). When a worker's `claude` exits, its pane ends.

## The workflow (do it in this order)
1. **PLAN** — split the job into N *independent* sub-tasks (one per worker). Pick N deliberately (see Limits).
2. **SPAWN** — `orch spawn <name> <N> [workdir]`. Give workers a few seconds to boot (a pane showing a ready prompt = booted).
3. **BRIEF** — write each worker's brief to `$ORCH_HOME/runs/<name>/shared/agent-<i>.task.md`. A good brief is self-contained: the goal, hard constraints (what NOT to touch), exactly what to produce, **where to write its result + a done-flag to `touch`**, and how to use the bus.
4. **DISPATCH** — `orch send <name> <i> --file .../agent-<i>.task.md` for each booted worker.
5. **COORDINATE via the bus** — tell workers to post findings to `shared/bus.md` (lines prefixed `[Wn]`) and to read it. When one discovers something (a bug class, a shared fix needed), the others act on it. The bus is the fleet's shared memory.
6. **MONITOR (your core job)** — periodically `orch read` each pane + read `bus.md`. Catch wrong-roads *early* and correct them with a nudge. Watch for: off-task drift, dead-ends, forbidden actions, or stalls. Re-check on a cadence (~80–600s) so you stay free between passes; a tighter cadence = closer watch.
7. **COLLECT** — each worker `touch`es a done-flag (e.g. `shared/agent-<i>.done`) + writes `agent-<i>.result.md`. Poll the flags (background loop or `orch status`) so you know when all are done.
8. **VERIFY + TEAR DOWN** — read the results, *verify them adversarially* (don't trust blindly — have a DIFFERENT worker try to refute each finding), then `orch kill <name>`. **Report a consolidated sign-off BEFORE killing sessions.**

## Patterns that work (battle-tested)
- **Find → verify:** some workers FIND issues; a *different* worker VERIFIES each finding. Independent eyes kill false positives.
- **Brief neutrally:** don't pre-declare the cause ("verify *whether/why* X is wrong", not "fix the X bug") — workers investigate instead of rubber-stamping your assumption. (This repeatedly caught the lead being wrong.)
- **One owner per shared file:** if several workers would edit the same shared file, assign ONE owner; the rest request changes via the bus — else their git commits collide.
- **Commit-local, lead pushes:** workers commit only their own files (behind a `flock` on a repo-local lockfile), do NOT push; the lead verifies then pushes. Use `git show --stat <hash>` to confirm each commit is own-files-only (workers must `git add <own paths>`, never `-A`).
- **3× cross-verify for high-stakes:** R1 audit → R2 adversarially refute R1 → R3 confirm survivors.

## Nudging / un-sticking a worker
- `orch send` only sends **single-line** messages (or `--file`). Long text with newlines will submit early — put it in a file.
- To clear a stuck/garbled input draft, drive tmux directly:
  `pane=$(sed -n '1p' $ORCH_HOME/runs/<s>/panes.txt)` then `tmux send-keys -t "$pane" Escape; tmux send-keys -t "$pane" C-a; tmux send-keys -t "$pane" C-k` then your clean message, then a **separate** `tmux send-keys -t "$pane" Enter`.
- A long message typed via send-keys sometimes needs `Enter` sent **twice** to submit. Never type onto an existing draft (it concatenates).

## Limits / gotchas
- **PERMISSIONS (the #1 blocker):** the permission classifier may *deny* autonomous spawns/sends. If `orch`/`tmux` calls get blocked, the user must add allow-rules to `~/.claude/settings.local.json`: `Bash(orch:*)` and `Bash(tmux:*)`. Run `orch doctor` to print them.
- **SCALE:** workers are real sessions consuming real usage — size the fleet to the work AND to the user's plan. If the account rate-limits, fleets degrade; prefer fewer, better-briefed workers.
- **TUI height:** don't cram many panes into one window — the worker TUI needs rows. For many workers, spawn separate sessions (one `orch spawn` per target) or batch them.
- **Tear down finished fleets** (`orch kill`) to free resources + your attention. Check live sessions with `orch status`.

## When NOT to use this
For a single quick task, just do it yourself or use one subagent. Reach for the fleet
only when the work is genuinely parallel, multi-target, and long enough that one lead
managing many workers beats serial execution.
