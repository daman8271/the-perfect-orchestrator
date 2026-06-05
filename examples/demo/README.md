# Demo: 3-worker self-verifying repo audit

The smallest fleet that shows the whole idea — including the part that matters:
**worker 3 exists to tear apart what workers 1–2 found.**

## What it does

| worker | role | brief |
|---|---|---|
| W1 | FIND | inventory every TODO / FIXME / HACK / XXX comment, judge which are live risks |
| W2 | FIND | check the README's claims against the actual code — what's stale or untrue? |
| W3 | VERIFY | independently re-derive W1's and W2's findings; CONFIRM or REFUTE each, with evidence |

## Run it

```bash
cd the-perfect-orchestrator/examples/demo

REPO=~/some-git-repo        # any repo you want audited
orch spawn demo 3 "$REPO"

SHARED=~/.orch/runs/demo/shared
for i in 1 2 3; do
  sed "s|{{REPO}}|$REPO|g" agent-$i.task.md > "$SHARED/agent-$i.task.md"
done

orch send demo 1 --file "$SHARED/agent-1.task.md"
orch send demo 2 --file "$SHARED/agent-2.task.md"
# wait for agent-1.done and agent-2.done (orch status demo), THEN:
orch send demo 3 --file "$SHARED/agent-3.task.md"

watch -n 10 orch status demo        # or: orch read demo 1
```

When `agent-3.done` appears, read `agent-3.result.md` — that's your **verified**
audit: findings that survived an independent adversarial pass, with the false
positives explicitly called out.

```bash
orch kill demo
```

## The better way: let the lead drive

Open Claude Code, type `/orch`, and say:

> Run the 3-worker self-verifying audit from examples/demo against this repo.

The lead session will spawn, brief, dispatch, monitor, sequence W3 after W1/W2,
collect, and report — that's the actual product.
