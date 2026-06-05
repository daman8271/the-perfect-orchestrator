# Contributing

PRs and issues are welcome — this project came out of real production use, and the
bar for changes is the same: **does it survive contact with a real fleet?**

## Ground rules

- Keep the core dependency-free: bash + tmux + the Claude Code CLI. No daemons, no
  servers, no message brokers. File-based coordination is a feature, not a TODO.
- `shellcheck bin/orch install.sh` must pass (CI enforces it).
- New patterns for [docs/PATTERNS.md](docs/PATTERNS.md) should state what was
  actually run and what went wrong without the pattern — battle scars over theory.
- Security-relevant changes (allowlist, credentials handling) get extra scrutiny;
  explain the threat model in the PR description.

## Dev loop

```bash
./install.sh          # symlinks bin/orch — edits are live immediately
orch doctor
orch spawn test 2 /tmp/some-git-repo
orch status test
orch kill test
```

## Ideas wanted

See the Roadmap in [README.md](README.md) — `orch verify` (the Verification Matrix)
and `orch demo` are the highest-impact contributions right now.
