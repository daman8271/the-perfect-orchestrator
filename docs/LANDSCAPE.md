# The Claude-fleet orchestration landscape

*A source-verified survey of every public project we could find that orchestrates
multiple Claude Code sessions — snapshot **2026-06-05**. Method: multi-agent deep
research (5 search angles, 15 primary sources fetched, 74 claims extracted, top 25
verified by independent 3-vote adversarial panels; 24 confirmed, 1 refuted). Star
counts and project status are point-in-time.*

## The specific pattern

What this repo implements — and what we surveyed for:

> A **LEAD Claude Code session** spawns N **interactive Claude Code workers in tmux**,
> dispatches **per-worker task brief files**, coordinates via a **shared file bus**,
> **monitors panes and nudges** stuck workers, collects **done-flags**, and
> **adversarially cross-verifies results** between workers.

## Closest implementations, ranked

### 1. primeline-ai/claude-tmux-orchestration — Mar 2026
Lead Claude in tmux window 0 spawns full interactive workers
(`claude --dangerously-skip-permissions` in new windows, prompts via tmux buffers);
coordination is pure files (`_orchestrator/workers/*.json`, `inbox/`, `results/`,
`.ready`/`.stop` flags, `log.jsonl`) — "no custom servers, no daemons, no IPC."
**Differences:** the lead is kept alive by an external bash `heartbeat.sh` loop
rather than self-pacing; no adversarial verification of results.

### 2. Claude Code "Agent Teams" (Anthropic, first-party) — ~Apr 2026
Experimental (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`, v2.1.32+). Lead session +
full-CLI teammates, optional tmux split-pane display, file-based task list with
file-locked claiming, push-style mailbox messaging. Documents adversarial
*hypothesis debate* during investigation. **Differences:** experimental and
disabled by default; debate-during-investigation is not post-hoc verification of
completed results; tmux optional.

### 3. dbmcco "orchestrating-tmux-claudes" skill (claude-agent-toolkit) — Oct 2025
A published Claude skill: COORDINATOR Claude splits its window into panes of
claude/codex workers, dispatches via `tmux send-keys` (Enter sent separately),
monitors via a capture-pane → Haiku-classifier → `/tmp/pane-N-state.json` loop.
**Differences:** panes not sessions, per-pane state files instead of a shared bus,
no brief files, no cross-verification.

### 4. Jedward23/Tmux-Orchestrator — Jun 2025 (~1.8k ★, dormant since Jul 2025)
The original viral implementation: three-tier hierarchy (Orchestrator → Project
Managers → Engineers), messaging via a send-keys wrapper script, pane monitoring,
self-scheduled check-ins. **Differences:** no file bus, no done-flags (in-band
STATUS messages), top-down "trust but verify" rather than adversarial peer review.
Its 334 forks (incl. absmartly's, which only added crash recovery + hooks) signal
sustained demand for a maintained successor.

### 5. EPAM Octobots (arozumenko/octobots) — Mar 2026
Six role-based interactive Claude workers tiled in tmux, SQLite (WAL) "taskbox" +
shared `board.md` whiteboard, Telegram in/out. **Difference that disqualifies it:**
the supervisor is deterministic Python — "No LLM involved" — so there is no lead
*agent* at all.

## Adjacent — different category

- **smtg-ai/claude-squad** (~7.7k ★) — tmux + git-worktree session *manager*;
  entirely human-driven TUI; no orchestration layer of any kind. Its popularity
  proves the demand for many-sessions; it deliberately doesn't automate command.
- **Claude Swarm / SwarmSDK (parruda)** — MCP request/response delegation, headless,
  zero tmux; the successor abandoned multi-process orchestration entirely. GitHub
  repos were removed sometime before 2026-06-05 (gems remain).
- Headless SDK swarms, agent farms, worktree parallelizers — no live lead, no
  interactive workers, or both.

## Where this repo differs from all of the above

To the best of our (verified) knowledge, **no public harness implements
lead-driven adversarial cross-verification of completed worker results** — the
find→verify / refute→confirm loop that is this project's core design rule. Every
other element (tmux workers, file bus, briefs, done-flags, monitor+nudge) exists
somewhere; the verification layer is the piece we could not find anywhere.

## Honest caveats

- Survey is GitHub-and-docs-centric; private builds and Discord-only projects may exist.
- One detailed claim about primeline's monitoring internals failed verification
  (0-3) and was excluded; its architecture claims all passed (3-0).
- This space moves fast — treat every number above as a 2026-06-05 snapshot.
  (Link rot is already real: one vendor article 403s, one major project's repos 404.)
