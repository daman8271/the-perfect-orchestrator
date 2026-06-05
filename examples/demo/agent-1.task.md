# Worker 1 of 3 — TODO/debt inventory (FINDER)

## Goal
Inventory every TODO, FIXME, HACK, and XXX comment in {{REPO}}. For each: file:line,
the comment text, and your judgment — is this a live risk, stale noise, or already
fixed elsewhere? Judge from the surrounding code, not the comment alone.

## Hard constraints
- Read-only: do NOT edit, create, or delete any file in {{REPO}}.
- Stay inside {{REPO}}.

## Deliverable
Write your full inventory as a markdown table to `agent-1.result.md` in the shared
workspace (the directory this brief lives in), with a 3-line summary on top
(counts by severity).

## Done signal
`touch agent-1.done` in the shared workspace when — and only when — finished.

## Coordination
Append notable discoveries to `bus.md` as single lines prefixed `[W1]`.
Read `bus.md` between major steps; if a peer reports something relevant to your
territory, investigate it.

## Autonomy
Work fully autonomously. Never wait for confirmation.
