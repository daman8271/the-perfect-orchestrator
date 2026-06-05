# Worker 2 of 3 — README truth check (FINDER)

## Goal
Check every concrete claim in {{REPO}}'s README (and other top-level docs) against
the actual code: commands that should exist, flags, file paths, install steps,
feature claims, badges. Classify each claim: TRUE / STALE / FALSE, with evidence
(file:line or command output).

## Hard constraints
- Read-only on the repo. You MAY run obviously-safe verification commands
  (`--help`, `--version`, listing files); do NOT run anything that mutates state.
- Stay inside {{REPO}}.

## Deliverable
Write your claim-by-claim table to `agent-2.result.md` in the shared workspace,
with a 3-line summary on top (counts of TRUE/STALE/FALSE).

## Done signal
`touch agent-2.done` in the shared workspace when — and only when — finished.

## Coordination
Append notable discoveries to `bus.md` as single lines prefixed `[W2]`.
Read `bus.md` between major steps.

## Autonomy
Work fully autonomously. Never wait for confirmation.
