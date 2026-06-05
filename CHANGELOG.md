# Changelog

## 0.1.0 — 2026-06-06

Initial public release.

- `orch` CLI: `spawn` / `send` / `read` / `status` / `kill` / `doctor` / `worker`
- Isolated worker config: auto-permissions allowlist, shared credentials,
  no inherited hooks; `rm` deliberately not allowlisted
- Shared-workspace protocol: `bus.md` message bus, per-worker task briefs,
  result files, done-flags
- `/orch` Claude Code skill: the full lead playbook (workflow, battle-tested
  patterns, nudge mechanics, limits)
- Docs: operations playbook (PATTERNS.md), source-verified landscape survey
  (LANDSCAPE.md), security model (SECURITY.md)
- Example: 3-worker self-verifying repo audit (examples/demo)
