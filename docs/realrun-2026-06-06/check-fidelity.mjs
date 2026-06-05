// Fidelity check: every line rendered by src/RealRun.tsx must be a contiguous
// substring of the raw transcript bundle (leading wrap-spaces trimmed).
import { readFileSync, readdirSync } from "fs";

const src = readFileSync(new URL("../src/RealRun.tsx", import.meta.url), "utf8");
const bundleFiles = [
  "capture.log",
  "lead-session.log",
  "commands.log",
  "shared/bus.md",
  "shared/agent-1.result.md",
  "shared/agent-2.result.md",
  "shared/agent-3.result.md",
];
const corpus = bundleFiles
  .map((f) => readFileSync(new URL(f, import.meta.url), "utf8"))
  .join("\n");

// extract every `text: "..."` literal from the EVENTS array
const needles = [];
const re = /text: "((?:[^"\\]|\\.)*)"/g;
let m;
while ((m = re.exec(src))) needles.push(JSON.parse(`"${m[1]}"`));
// plus the banner strings (rendered outside EVENTS)
needles.push(
  "17 CONFIRMED, 0 REFUTED",
  "Zero false positives in W1/W2 — both accurate.",
  "Treated each finding as wrong until the code proved it. The code proved them right."
);

let fail = 0;
for (const raw of needles) {
  const n = raw.replace(/^\s+/, "").trim();
  if (!n) continue; // gap lines
  if (!corpus.includes(n)) {
    fail++;
    console.log(`MISSING: ${JSON.stringify(n)}`);
  }
}
console.log(fail === 0 ? `OK — all ${needles.length} rendered lines exist verbatim in the bundle` : `${fail} FAILURES`);
process.exit(fail === 0 ? 0 : 1);
