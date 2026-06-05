[W1] Zero genuine TODO/FIXME/HACK/XXX markers in the entire repo — all 4 grep hits are meta-references in docs (CONTRIBUTING.md:9, examples/demo/README.md:10, examples/demo/agent-1.task.md:1,4).
[W1] Also swept TBD/WIP/deprecated/workaround/kludge/unimplemented: zero hits. No annotated debt anywhere; full inventory in agent-1.result.md.
[W1] Note for W2/W3: examples/demo/agent-*.task.md are templates with {{REPO}} placeholders — the live briefs in this shared dir were instantiated from them.
[W2] README truth check done: 34 TRUE / 1 STALE / 0 FALSE / 5 unverifiable-external. Full table in agent-2.result.md.
[W2] Only STALE: README commands table says `orch spawn` creates "(bus.md, briefs, results, done-flags)" — spawn creates only bus.md+panes.txt (bin/orch:64-66); briefs/results/done-flags come later. CLI's own --help is accurate.
[W2] Caveats worth W3's eyes: (a) "hooks, history, settings untouched" is true but ~/.claude/plugins is symlinked WRITABLE into worker config (bin/orch:219-221); (b) "tmux ≥ 3.0" never enforced; readlink -f needs macOS ≥ 12.3.
[W2] Non-claim find: heroB.png + heroC.png (~9.4MB) git-tracked at repo root, referenced nowhere — leftover drafts.
[W3] Verification done: 17 CONFIRMED, 0 REFUTED, 1 confirmed-with-minor-correction, 4 UNVERIFIABLE (agreed). Zero false positives in W1/W2 — both accurate. Full matrix in agent-3.result.md.
[W3] Single most important confirmed finding: W2's STALE item — README.md:121 says `orch spawn` creates "(bus.md, briefs, results, done-flags)" but cmd_spawn (bin/orch:64-66) creates only bus.md+panes.txt. Real doc-vs-code drift.
[W3] Minor correction to W1: it says "4 PNGs excluded as binary" — there are actually 5 (hero, social-card, verification, heroB, heroC). Conclusion (zero markers) unchanged.
[W3] Extends W2's heroB/heroC find: assets/social-card.png (1.05MB) is ALSO referenced nowhere in-repo (likely a website OG asset, less clearly cruft than the root heroB/heroC drafts).
[W3] Net-new (outside both briefs, not a refutation): config/worker-settings.json:16 `skipAutoPermissionPrompt:true` is NOT a documented Claude Code settings key; may be ignored. `defaultMode:auto` IS valid (research-preview mode). Maintainer's call.
