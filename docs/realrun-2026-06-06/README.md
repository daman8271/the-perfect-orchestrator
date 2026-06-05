# realrun/ — raw proof bundle for the RealRun replay video

This is the **unedited record of a genuine fleet session**, run on **2026-06-06,
04:44–04:54 local**, on this machine. The Perfect Orchestrator's own
`examples/demo` (3-worker self-verifying audit) was run for real against its own
repository (`git clone https://github.com/daman8271/the-perfect-orchestrator`,
clean checkout at `/tmp/demo-target`).

The video `out/realrun-web.mp4` is a time-compressed replay of this session.
**Every line of text rendered in the video exists verbatim in this bundle** —
nothing was invented, paraphrased, or staged. ~10 minutes of real wall-clock are
compressed to ~31 s; the video watermarks this ("real session · 2026-06-06 ·
time compressed").

## What happened (real timeline)

| time | event |
|---|---|
| 04:44 | `orch spawn demo 3 /tmp/demo-target` — 3 Claude Code workers in tmux panes |
| 04:45 | W1 (TODO/debt finder) + W2 (README truth-checker) dispatched via `orch send --file` |
| 04:46 | `agent-1.done` — W1: zero genuine debt markers in the repo (all 4 grep hits are meta-references) |
| 04:48 | `agent-2.done` — W2: 34 TRUE / **1 STALE** / 0 FALSE README claims |
| 04:48 | W3 (adversarial verifier) dispatched — only after both finder done-flags |
| 04:53 | `agent-3.done` — verdicts: **17 CONFIRMED, 0 REFUTED, 1 confirmed-with-minor-correction**, 4 UNVERIFIABLE (agreed). W3 independently re-derived every finding and **caught a real error in W1's report** (claimed "4 PNGs excluded as binary"; there are 5) and confirmed W2's STALE finding as genuine doc-vs-code drift (README.md:121 vs bin/orch:64–66) |
| 04:54 | `orch kill demo` |

## Files

- `capture.log` — 39 timed snapshots (~every 15 s while the fleet ran): `date +%T`,
  `orch status demo`, and the last 12 lines of each of the 3 worker panes.
  Recorded live by `capture.sh` (included). This is the independent, third-party-style
  record — it shows the actual Claude Code TUIs working.
- `lead-session.log` — verbatim lead-side transcript: every command the lead ran
  and the stdout each returned.
- `commands.log` — minimal command-only log written live during the run.
- `shared/` — byte-for-byte copy of the fleet's shared workspace at teardown:
  - `bus.md` — the real message bus (every `[W1]/[W2]/[W3]` line)
  - `agent-{1,2,3}.task.md` — the dispatched briefs (instantiated from
    `examples/demo/agent-*.task.md`, `{{REPO}}` → `/tmp/demo-target`)
  - `agent-{1,2,3}.result.md` — the workers' actual deliverables, including W3's
    full verification matrix
  - `agent-{1,2,3}.done` — the (empty) done-flags with their real mtimes

## How to check the video against this bundle

Every rendered line in `src/RealRun.tsx` is a contiguous substring of a line in
`lead-session.log`, `shared/bus.md`, `shared/agent-3.result.md`, or `capture.log`
(long lines hand-wrapped for the 1080p frame; wraps marked by leading spaces).
`grep -F` any rendered line against this directory to verify.
