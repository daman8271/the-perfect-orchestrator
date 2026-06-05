# Worker 3 of 3 — adversarial VERIFIER

## Goal
Workers 1 and 2 have finished. Their findings are in `agent-1.result.md` and
`agent-2.result.md` in the shared workspace (this directory). Your job is to
**tear them apart**: independently re-derive every finding from the actual code in
{{REPO}}. Do not trust their reasoning — verify from primary evidence. For each
finding output a verdict: CONFIRMED / REFUTED / UNVERIFIABLE, with your own
evidence (file:line). Be actively skeptical; assume each finding is wrong until
the code proves otherwise.

## Hard constraints
- Read-only on the repo.
- Re-derive independently FIRST, then compare against their claims — don't anchor.

## Deliverable
Write the verification matrix (finding × verdict × evidence) to
`agent-3.result.md`, with a summary on top: how many findings survived, how many
were false positives, and the single most important confirmed finding.

## Done signal
`touch agent-3.done` when — and only when — finished.

## Coordination
Post your final tallies to `bus.md` prefixed `[W3]`. If you refute something,
say which worker's finding and why in one line.

## Autonomy
Work fully autonomously. Never wait for confirmation.
