# W3 — Adversarial verification of W1 + W2

## Summary
- **Findings examined: 18** (W1: 2 substantive claims + 4-row inventory; W2: 12 substantive claims/discoveries).
- **CONFIRMED: 17 · REFUTED: 0 · CONFIRMED-with-correction: 1 · UNVERIFIABLE (agreed): 4 marketing/external-history claims.**
- **False positives found in their work: 0.** Both finders were accurate and, if anything, *understated*.
- **Single most important confirmed finding:** W2's lone STALE item — the README commands table (README.md:121) claims `orch spawn` creates a "shared workspace (bus.md, briefs, results, done-flags)", but `cmd_spawn` (bin/orch:64–66) creates **only** `bus.md` + `panes.txt`; briefs/results/done-flags are written later by the lead/workers. The CLI's own `--help` (bin/orch:24) is accurate. This is the one real doc-vs-code drift in the repo.
- **One thing BOTH finders missed** (out of their briefs' scope, flagged for completeness): `config/worker-settings.json:16` sets `"skipAutoPermissionPrompt": true`, which is **not a documented Claude Code settings key** (verified against code.claude.com/docs/en/settings.md). `defaultMode: "auto"` *is* valid (a documented research-preview mode). See note below.

---

## W1 — TODO/debt inventory

| # | W1 claim | Verdict | My independent evidence |
|---|---|---|---|
| 1 | Zero genuine TODO/FIXME/HACK/XXX markers; all 4 hits are meta-references | **CONFIRMED** | My own `grep -rIni -E 'todo\|fixme\|hack\|xxx'` returns exactly 4 lines: `CONTRIBUTING.md:9`, `examples/demo/agent-1.task.md:1`, `examples/demo/agent-1.task.md:4`, `examples/demo/README.md:10`. Each, read in context, is documentation *about* TODOs (CONTRIBUTING:9 literally says "a feature, not a TODO"; the demo files are the task template). None is annotated debt. |
| 2 | Adjacent markers (TBD/WIP/deprecated/workaround/kludge/unimplemented…) — zero hits | **CONFIRMED** | My `grep -rIni -E '@todo\|tbd\|wip\|deprecated\|workaround\|temporar\|kludge\|not implemented\|unimplemented'` returns **nothing**. |
| 3 | Coverage: 22 files, 4 PNGs excluded as binary | **CONFIRMED (minor count correction)** | `find` confirms 22 non-`.git` files. But there are **5** PNGs, not 4 (`assets/hero.png`, `assets/social-card.png`, `assets/verification.png`, `heroB.png`, `heroC.png`). Doesn't change the conclusion (all binary, no markers) — W1's verdict stands; only the parenthetical PNG count is off by one. |

**W1 verdict: fully CONFIRMED.** The repo carries zero annotated technical debt.

---

## W2 — README / docs truth check

| # | W2 claim | Verdict | My independent evidence |
|---|---|---|---|
| A | **STALE:** `orch spawn` "creates bus.md, briefs, results, done-flags" | **CONFIRMED** | bin/orch:64–66 creates only `bus.md` + `panes.txt`. README.md:121 overstates; bin/orch:24 (`--help`) is correct. The single real drift. |
| B | Site `the-perfect-orchestrator.vercel.app` live (HTTP 200) | **CONFIRMED** | `curl -sI` → `HTTP/2 200`. |
| C | GitHub repo exists; CI badge resolves | **CONFIRMED** | repo `curl` → 200; badge URL → 200; `git remote -v` matches `daman8271/the-perfect-orchestrator`. |
| D | `defaultMode: auto` set | **CONFIRMED** | config/worker-settings.json:3. (Also independently verified `auto` is a *valid* documented mode — research preview.) |
| E | `rm` NOT allowlisted (`mv`/`cp`/`chmod` are) | **CONFIRMED** | No `rm` token in the allow array; `Bash(mv:*)`, `Bash(cp:*)`, `Bash(chmod:*)` all present. |
| F | Credentials shared via symlink | **CONFIRMED** | bin/orch:215–217 `ln -sf ~/.claude/.credentials.json`. (Note: "read-only symlink" is intent — a symlink does not itself make the target read-only; the *file's* perms govern. Did not probe live perms — blocked by classifier and not needed for the claim, which is about the sharing mechanism.) |
| G | Caveat: `~/.claude/plugins` symlinked **writable** into worker config | **CONFIRMED** | bin/orch:219–221 `ln -s "$HOME/.claude/plugins" "$cfg/plugins"` — a dir symlink; writes pass through. README's "hooks, history, settings untouched" is literally true (those use `CLAUDE_CONFIG_DIR`), but plugins are genuinely shared live. Accurate caveat. |
| H | Caveat: `readlink -f` (bin/orch:9) breaks on old macOS | **CONFIRMED** | Code uses `readlink -f`, which is GNU/coreutils; BSD `readlink` lacked `-f` until macOS 12.3. Legitimate portability concern for a "Linux **or macOS**" tool. |
| I | Caveat: "tmux ≥ 3.0" never enforced | **CONFIRMED** | doctor (bin/orch:170–173) and install.sh:12 check `command -v tmux` only — presence, never version. |
| J | `heroB.png` + `heroC.png` (~9.4 MB) git-tracked, referenced nowhere | **CONFIRMED (and broader)** | `git ls-files` tracks both; `grep -rIl` finds **zero** references to either in any tracked text. Sizes: heroB 5.45 MB + heroC 4.36 MB. **Additional:** `assets/social-card.png` (1.05 MB) is *also* referenced nowhere in-repo — though that one is a plausible OG/social asset used by the website, so less clearly cruft than the two root-level `heroB/heroC` drafts. |
| K | Marketing/anecdotal claims ("learned in production", "caught the lead being wrong", "built by its own fleet"); competitor comparison rows | **UNVERIFIABLE (agreed)** | No in-repo artifact can confirm or refute. W2's UNVERIFIABLE classification is the correct, honest call. |
| L | SECURITY.md / CONTRIBUTING.md / examples consistent with code | **CONFIRMED** | Spot-checked: SECURITY.md:18–21 (isolated config + read-only-symlink wording) matches bin/orch:230 & 215–217; CONTRIBUTING ground rules match the dependency-free design; LICENSE:1–3 = "MIT … 2026 danny (daman8271)". |

**W2 verdict: fully CONFIRMED.** Every substantive claim re-derived from primary evidence. The "34 TRUE / 1 STALE / 0 FALSE / 5 unverifiable" headline tally is loosely counted (the numbered table runs to 44 rows with sub-items), but no individual verdict is wrong.

---

## Note on the one thing both finders missed
`config/worker-settings.json:16` → `"skipAutoPermissionPrompt": true` is **not in Claude Code's documented settings schema** (checked code.claude.com/docs/en/settings.md and /permissions.md). It is either an internal/undocumented or legacy flag and may be silently ignored. This was outside both briefs (W1 = debt markers, W2 = README claims — and the README makes no claim about this key), so it is **not** a refutation of either worker — it's a net-new observation surfaced during independent re-derivation. Worth a maintainer's eyes; the file passes CI's `json.tool` validity check regardless, so it's a no-op at worst.

## Method
Re-derived every finding from the actual code/files **before** reading the finders' reasoning line-by-line: re-ran all greps, `curl`ed the three external URLs, re-read the cited bin/orch line ranges, and re-checked file references. Treated each finding as wrong until the code proved it. The code proved them right.
