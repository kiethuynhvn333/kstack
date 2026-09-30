#!/usr/bin/env sh
# Check the repo's structure before a commit, at session end, and during the weekly review.
# Stops at the first problem with a message saying what to fix. Projects and segments are read
# from the folders on disk, so this works for any setup without editing.
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$ROOT"

fail() { echo "✗ $*"; exit 1; }

# 1. Required files
for f in AGENTS.md rules/setup.md rules/analysis.md rules/actions.md rules/memory.md \
         knowledge/INDEX.md knowledge/universal-learnings.md knowledge/meta/inbox.md \
         knowledge/meta/review-log.md scripts/next-id.sh \
         projects/_template/worklog.md projects/_template/_segment/decisions.md \
         projects/_template/_segment/open-items.md projects/_template/_segment/experiments.md \
         projects/_template/_segment/mistakes-and-learnings.md; do
  test -f "$f" || fail "Missing required file: $f"
done

# 2. Every project has a worklog, deliverables/, and 4 tracking files in each segment folder
TRACKING="decisions.md open-items.md experiments.md mistakes-and-learnings.md"
tracking_files=""
for p in projects/*/; do
  p="${p%/}"
  test "$(basename "$p")" = "_template" && continue
  test -f "$p/worklog.md" || fail "Missing: $p/worklog.md"
  test -d "$p/deliverables" || fail "Missing folder: $p/deliverables/"
  segs=0
  for s in "$p"/*/; do
    s="${s%/}"
    test "$(basename "$s")" = "deliverables" && continue
    segs=$((segs + 1))
    for f in $TRACKING; do
      test -f "$s/$f" || fail "Missing: $s/$f (copy it from projects/_template/_segment/)"
      tracking_files="$tracking_files $s/$f"
    done
  done
  test "$segs" -gt 0 || fail "$p has no segment folder — add at least cross-segment/ (see projects/_template/README.md)"
done

# 3. Size limits (rule 45 — keep active context compact)
check_lines() {
  n="$(wc -l < "$1" | tr -d ' ')"
  test "$n" -le "$2" || fail "Too long: $1 has $n lines (limit $2) — split or archive, don't just trim"
}
check_lines AGENTS.md 60
for f in rules/*.md; do check_lines "$f" 60; done
check_lines knowledge/INDEX.md 100
check_lines knowledge/meta/inbox.md 100
for f in $tracking_files; do
  case "$f" in */decisions.md|*/open-items.md) check_lines "$f" 150 ;; esac
done
for f in $(find knowledge -type f -name '*.md' ! -name INDEX.md); do check_lines "$f" 200; done

# 4. IDs: right prefix for the file, and never used twice across the repo (rule 43)
ids="$(mktemp)"; trap 'rm -f "$ids"' EXIT
for f in $tracking_files knowledge/meta/inbox.md; do
  case "$f" in
    */decisions.md) want=D ;; */open-items.md) want=O ;; */experiments.md) want=E ;;
    */mistakes-and-learnings.md) want=C ;; */inbox.md) want=K ;;
  esac
  awk -F'|' -v f="$f" '$2 ~ /^ *[A-Z]-[0-9][0-9][0-9]+ *$/ { id=$2; gsub(/ /, "", id); print id "\t" f }' "$f" >> "$ids"
  bad="$(awk -F'|' -v w="$want" '$2 ~ /^ *[A-Z]-[0-9][0-9][0-9]+ *$/ { id=$2; gsub(/ /, "", id); if (substr(id,1,1) != w) print id }' "$f")"
  test -z "$bad" || fail "Wrong ID prefix in $f: $bad (this file uses $want-)"
done
dups="$(cut -f1 "$ids" | sort | uniq -d | tr '\n' ' ')"
test -z "$dups" || fail "Duplicate IDs: $dups— relabel the newer copy with scripts/next-id.sh"

# 5. Every skill loads its rules/ file(s) as Step 0 — a table in AGENTS.md alone is not a trigger
for f in skills/*/SKILL.md; do
  test -f "$f" || continue
  step0="$(grep -A1 'Step 0 — read first' "$f" || true)"
  test -n "$step0" || fail "Skill missing its Step 0 rules/ line: $f"
  for r in $(printf '%s\n' "$step0" | grep -oE 'rules/[a-z-]+\.md'); do
    test -f "$r" || fail "$f points to missing $r"
  done
done

# 6. No leftover TODOs in active files
if grep -REn '\[TODO|TODO:' AGENTS.md rules knowledge projects 2>/dev/null; then
  fail "Unresolved TODO in an active file (above)"
fi

# 7. Setup status (a note, not a failure — the public template ships without these)
for f in profile.md workspace.md; do
  test -f "$f" || echo "• $f not created yet — say \"set up\" to your agent (rules/setup.md)"
done

echo "✓ Validation passed."
