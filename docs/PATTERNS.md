# Fleet patterns — the operations playbook

Everything here was learned by running real production work through fleets:
multi-platform scraper audits, cross-module bug sweeps, parallel migrations.
None of it is theoretical, and most of it was learned the hard way.

## 1. Find → verify (the core pattern)

Never let the worker that *found* something be the one that *confirms* it.

```
W1..W3  →  FIND     (each scans its own territory, posts findings to bus.md)
W4      →  VERIFY   (re-derives every finding from scratch; CONFIRMED / REFUTED)
```

Why it works: a finder is invested in its finding; a verifier is invested in tearing
it down. Independent context windows mean the verifier can't inherit the finder's
wrong assumptions. In practice this kills a surprising number of confident,
plausible, *wrong* findings before they reach you.

For high-stakes work, use **three rounds**: R1 audits → R2 adversarially refutes
everything R1 claimed → R3 confirms the survivors. Findings that survive R2 are
worth acting on.

## 2. Brief neutrally

Wrong: *"Worker 2: fix the timezone bug in the report generator."*
Right: *"Worker 2: the report timestamps may or may not be wrong. Determine whether
they are, find the root cause if so, and report evidence either way."*

Pre-declaring the cause turns a worker into a rubber stamp — it will "find" whatever
you told it was there. Neutral briefs make workers investigate. This pattern has
repeatedly caught the *lead's own diagnosis* being wrong, which is exactly when it
pays for itself.

## 3. The brief is the contract

A good `agent-<n>.task.md` is fully self-contained:

```markdown
# Worker 3 of 5 — <one-line mission>
## Goal            <what done looks like, concretely>
## Hard constraints <what NOT to touch; files owned by other workers>
## Deliverable     write findings to shared/agent-3.result.md
## Done signal     touch shared/agent-3.done when (and only when) finished
## Coordination    append discoveries to shared/bus.md prefixed [W3];
                   read bus.md every few minutes and act on peers' findings
## Autonomy        work fully autonomously; never wait for confirmation
```

If a worker has to guess, it will guess wrong in the most expensive way available.

## 4. One owner per shared file

Two workers editing one file = collided commits and merge hell. Assign ONE owner per
shared file; everyone else posts change requests to the bus and the owner applies
them. The bus line format that works:

```
[W2] REQUEST → W4: utils/dates.py needs parse_ist() to accept epoch ms — blocking me
[W4] DONE: parse_ist() handles epoch ms, pushed to my branch — W2 unblocked
```

## 5. Commit-local, lead pushes

- Workers commit **only their own files**: `git add <own paths>` — never `-A`.
- Wrap commits in a lock so parallel `git commit` doesn't corrupt the index:
  `flock <repo>/.gitcommit.lock git commit -m "..."`.
- Workers do **NOT** push. The lead reviews each commit (`git show --stat <hash>` —
  confirm it touches only that worker's files), then pushes once, itself.

This single rule prevents nearly all fleet-induced git disasters.

## 6. Monitoring cadence

The lead's job after dispatch is **watching**, not waiting:

- `orch read <s> <n>` each pane on a cadence: ~80s (tight watch, risky work) to
  ~600s (long autonomous runs).
- Read `bus.md` every pass — workers often report blockers there before stalling.
- Catch wrong-roads *early*. The cost of a worker going down a rabbit hole grows
  with every minute it isn't corrected.
- Look for: off-task drift, dead-end loops, permission-prompt stalls, an input box
  with a half-typed draft (garbled send), or a worker waiting for confirmation it
  was told never to wait for.

## 7. Nudge mechanics (tmux is sharp — handle carefully)

- Nudges must be **single-line**: the TUI submits on newline.
- Never type onto an existing draft — text concatenates. Clear first:
  `Escape`, then `C-a`, then `C-k`, *then* the message, then a **separate** `Enter`.
- Long pasted messages sometimes need `Enter` twice to submit.
- For anything over a sentence, write a file and `orch send <s> <n> --file <path>`.

## 8. Sizing the fleet

- Workers are real Claude sessions consuming real usage. Size to the work, and to
  the plan paying for it — a rate-limited fleet degrades into a very expensive
  spinner. Prefer fewer, better-briefed workers.
- TUIs need terminal rows: past ~6 panes per window, spawn separate sessions
  (one per target) instead of cramming.
- For a single quick task, skip the fleet entirely. One good session beats a
  badly-supervised crowd.

## 9. Tear-down discipline

Report the consolidated, verified result **before** killing sessions — pane
scrollback is evidence, and it dies with the session. Then `orch kill <s>` promptly:
idle fleets burn attention even when they're not burning tokens.
