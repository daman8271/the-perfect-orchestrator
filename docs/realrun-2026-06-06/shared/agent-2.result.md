# W2 — README truth check: claim-by-claim verification

**Summary: 34 TRUE · 1 STALE · 0 FALSE · 5 UNVERIFIABLE** (external/marketing claims that can't be checked from inside the repo).
The README is unusually honest — every command, flag, path, and security claim checked out against `bin/orch`, `install.sh`, and `config/worker-settings.json`; the one STALE item is a minor overstatement of what `orch spawn` creates.
Notable non-claim discovery: `heroB.png` + `heroC.png` (~9.4 MB) are git-tracked at repo root, referenced nowhere.

## Badges & header (README.md:1–16)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1 | Hero image `assets/hero.png` | TRUE | File exists (1.36 MB) |
| 2 | Site `the-perfect-orchestrator.vercel.app` is live | TRUE | `curl -sI` → HTTP/2 200 |
| 3 | License: MIT | TRUE | LICENSE:1–3 — "MIT License / Copyright (c) 2026 danny (daman8271)" |
| 4 | Made with Bash | TRUE | `bin/orch:1`, `install.sh:1` — bash shebangs; no other languages |
| 5 | Requires tmux | TRUE | install.sh:12 hard-fails without tmux; bin/orch:170–173 (doctor) |
| 6 | CI badge → `workflows/ci.yml` | TRUE | `.github/workflows/ci.yml` exists (bash -n, shellcheck, json check); badge URL returns 200 |
| 7 | GitHub repo `daman8271/the-perfect-orchestrator` exists | TRUE | `curl` → 200; matches `git remote -v` |

## Intro & "How it works" (README.md:20–89)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 8 | Spawns N interactive Claude Code workers in tmux panes | TRUE | bin/orch:70–79 (`tmux new-session`/`split-window`, tiled), bin/orch:232 (`exec claude`) |
| 9 | Shared message bus `bus.md` | TRUE | bin/orch:65 creates it; status tails it (bin/orch:149) |
| 10 | Coordination is plain files — no servers/daemons/broker | TRUE | bin/orch uses only tmux + files under `~/.orch/runs/`; no listeners |
| 11 | `assets/verification.png` | TRUE | File exists (834 KB) |
| 12 | Worker protocol (task brief / `[Wn]` bus lines / result + done-flag / never wait) | TRUE | Matches skill/SKILL.md:30–35 and state layout in bin/orch:39–42; this very run follows it |
| 13 | Workers adversarially verify each other's results | TRUE (by protocol) | SKILL.md:35,38 and docs/PATTERNS.md §1 — it's the documented playbook; note: enforced by convention, not code |
| 14 | "Learned in production… repeatedly caught the lead's own wrong assumptions" | UNVERIFIABLE | Anecdotal; no artifact in repo can confirm |

## Quickstart (README.md:91–115)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 15 | `./install.sh` installs `orch` CLI + `/orch` skill | TRUE | install.sh:17 (symlink → `~/.local/bin/orch`), install.sh:23 (copies SKILL.md → `~/.claude/skills/orch/`) |
| 16 | `orch doctor` verifies setup + prints lead allow-rules | TRUE | bin/orch:166–199 — checks tmux/claude/credentials, prints `Bash(orch:*)`/`Bash(tmux:*)` JSON |
| 17 | `/orch <prompt>` puts session in command of fleet | TRUE | skill/SKILL.md frontmatter `name: orch` + full lead playbook |
| 18 | `orch spawn audit 4 ~/my-project` → tmux session `orch-audit` | TRUE | bin/orch:60 (`ses="orch-$session"`) |
| 19 | `orch send audit 1 --file …/agent-1.task.md` | TRUE | bin/orch:103–107 |
| 20 | `orch read audit 1` watches worker screen | TRUE | bin/orch:120–127 (`tmux capture-pane`) |
| 21 | `orch status audit` → panes + done-flags + bus tail | TRUE | bin/orch:129–150 |
| 22 | `orch kill audit` tears down | TRUE | bin/orch:152–164 |

## Commands table (README.md:117–127)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 23 | `spawn` creates "shared workspace (bus.md, briefs, results, done-flags)" | **STALE** | spawn itself creates only `bus.md` + `panes.txt` (bin/orch:64–66); briefs/results/done-flags are written *later* by lead/workers. The CLI's own help is accurate: "shared workspace (bus.md, panes.txt)" (bin/orch:24) |
| 24 | `send` is single-line; newline submits; `--file` for briefs | TRUE | bin/orch:110–112 rejects embedded newlines with that exact rationale |
| 25 | `read … [lines]` captures pane | TRUE | bin/orch:123 (default 50 lines) |
| 26 | `status [session]` lists fleets or one fleet's detail | TRUE | bin/orch:130–150 |
| 27 | `kill <session> \| --all` | TRUE | bin/orch:153–159 |
| 28 | `doctor` = dependency check + allow-rules | TRUE | bin/orch:166–199 |
| — | (table omits internal `orch worker` — disclosed as "(internal)" in `orch --help`, not a misclaim) | — | bin/orch:34–35 |

## Patterns & comparison (README.md:129–160)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 29 | Full playbook at `docs/PATTERNS.md` | TRUE | Exists; contents match the 5 bullets (find→verify, neutral briefs, one-owner, commit-local, 3× verify) |
| 30 | "Came from running real production work… not demos" | UNVERIFIABLE | Anecdotal |
| 31 | Full survey at `docs/LANDSCAPE.md`, snapshot 2026-06-05 | TRUE | Exists; header states snapshot 2026-06-05 + methodology |
| 32 | Comparison-table rows about competitors (Tmux-Orchestrator, claude-squad, etc.) | UNVERIFIABLE | External point-in-time claims; LANDSCAPE.md documents methodology but can't be independently confirmed offline |

## Security model (README.md:162–176)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 33 | Workers run with `defaultMode: auto` | TRUE | config/worker-settings.json:3 |
| 34 | Generous allowlist: git, node, python, file edits, network fetches | TRUE | config/worker-settings.json — `Bash(git:*)`, `Bash(node:*)`, `Bash(python3:*)`, `Edit`/`Write`, `Bash(curl:*)`/`WebFetch` |
| 35 | `rm` is NOT allowlisted | TRUE | Absent from the allow array (grep confirms; `mv`/`cp`/`chmod` are present, `rm` is not) |
| 36 | Credentials shared via symlink | TRUE | bin/orch:215–217 (`ln -sf ~/.claude/.credentials.json`) |
| 37 | Isolated config dir; "hooks, history, settings untouched" | TRUE (w/ caveat) | bin/orch:230 (`CLAUDE_CONFIG_DIR=$cfg`). Caveat: `~/.claude/plugins` is symlinked *writable* into worker config (bin/orch:219–221) and `~/.claude.json` is copied in (224–227) — hooks/history/settings genuinely untouched, but plugins are shared live |
| 38 | Tune `~/.orch/worker-config/settings.json` | TRUE | Seeded on first worker run (bin/orch:212–214); SECURITY.md:32 correctly says "after first run" |

## Requirements, roadmap, footer (README.md:178–217)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 39 | Linux or macOS, tmux ≥ 3.0 | TRUE (w/ caveats) | Nothing enforces the tmux version (doctor checks presence only); `readlink -f` (bin/orch:9) requires macOS ≥ 12.3 — older Macs fail |
| 40 | Requires Claude Code CLI, logged in | TRUE | install.sh:13; doctor warns if `~/.claude/.credentials.json` missing |
| 41 | Roadmap items (`orch verify`/`demo`/`watch`, telemetry, templates) are unimplemented | TRUE (correctly unchecked) | None appear in the command dispatch (bin/orch:235–243) — honest roadmap |
| 42 | MIT © 2026 danny (daman8271) | TRUE | LICENSE:1–3 |
| 43 | Site "built and QA'd by its own fleet" / "battle-tested by orchestrating the fleets it ships" | UNVERIFIABLE | Marketing; no repo artifact |
| 44 | CHANGELOG 0.1.0 matches shipped CLI | TRUE | `./bin/orch --version` → `orch 0.1.0`; command list matches |

## Other docs spot-checked
- **SECURITY.md** — consistent with code in every checkable particular (allowlist contents, symlink, lock/push workflow).
- **CONTRIBUTING.md / examples/demo** — referenced files all exist; demo task files are `{{REPO}}` templates (per W1's bus note).

## Non-claim discovery
- `heroB.png` (5.4 MB) + `heroC.png` (4.4 MB) are **git-tracked at repo root**, referenced by nothing (README uses `assets/hero.png`). Likely leftover drafts bloating the clone by ~9.4 MB.
