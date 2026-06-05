# W1 — TODO/FIXME/HACK/XXX inventory of /tmp/demo-target

**Live risks: 0 · Stale noise: 0 · Already fixed: 0 · Meta-references (not debt): 4**
The codebase contains **zero genuine debt markers**. All 4 grep hits are documentation *about* TODOs, not TODOs.
Verified per-file: `bin/orch`, `install.sh`, `.github/workflows/ci.yml`, `config/worker-settings.json`, `skill/SKILL.md` each have a marker count of 0 (case-insensitive, substring-level).

## Inventory

| # | Location | Text (abridged) | Classification | Judgment from surrounding code |
|---|---|---|---|---|
| 1 | `CONTRIBUTING.md:9` | "File-based coordination is a feature, not a TODO." | Meta-reference — not debt | Rhetorical use inside the ground-rules section ("Keep the core dependency-free"). It explicitly *rejects* treating file-based coordination as pending work. No risk. |
| 2 | `examples/demo/README.md:10` | "W1 \| FIND \| inventory every TODO / FIXME / HACK / XXX comment…" | Meta-reference — not debt | Demo documentation describing this very worker's role in the example fleet. Self-referential; no risk. |
| 3 | `examples/demo/agent-1.task.md:1` | "# Worker 1 of 3 — TODO/debt inventory (FINDER)" | Meta-reference — not debt | Title of the demo task brief template (the template this run was instantiated from, `{{REPO}}` placeholder intact). No risk. |
| 4 | `examples/demo/agent-1.task.md:4` | "Inventory every TODO, FIXME, HACK, and XXX comment in {{REPO}}…" | Meta-reference — not debt | Body of the same template. No risk. |

## Methodology / coverage notes

- Scanned every non-`.git` file (22 files total; 4 PNGs excluded as binary via `grep -I`).
- Searches run: case-sensitive `TODO|FIXME|HACK|XXX`; case-insensitive word-boundary `\b(todo|fixme|hack|xxx)\b`; substring-level per-file counts on all code/config files.
- Also swept adjacent debt markers (`@todo`, `TBD`, `WIP`, `deprecated`, `workaround`, `temporary`, `kludge`, `not implemented`, `unimplemented`): **zero hits** repo-wide.
- Conclusion: the repo carries no annotated technical debt. Any debt that exists is unannotated and would be W2/W3 territory (claims-vs-code drift), not comment-marker territory.
