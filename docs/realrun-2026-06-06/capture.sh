#!/usr/bin/env bash
# Honest capture loop for the real demo fleet run.
# Appends a timestamped snapshot (~every 15s): orch status + last 12 lines of each pane.
export PATH="$PATH:$HOME/.local/bin"
LOG=/root/tpo-video/realrun/capture.log
STOP=/root/tpo-video/realrun/capture.stop
while [ ! -f "$STOP" ]; do
  {
    echo "===== SNAPSHOT $(date +%T) ====="
    orch status demo 2>&1
    for n in 1 2 3; do
      echo "--- pane W$n (last 12 lines) ---"
      orch read demo $n 12 2>&1
    done
    echo
  } >> "$LOG"
  sleep 15
done
echo "===== CAPTURE STOPPED $(date +%T) =====" >> "$LOG"
