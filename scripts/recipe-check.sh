#!/usr/bin/env sh
# Trust-expiry check for knowledge/verified-recipes.md.
#   scripts/recipe-check.sh            for every ledger row with a query file + hash, say whether the
#                              file still matches the hash it was verified at (exit 1 if any is STALE/MISSING)
#   scripts/recipe-check.sh --hash f   print the hash to paste into the ledger (comments/whitespace/case ignored)
# A recipe's "verified" status only holds while its hash matches. Edit the query -> trust expires.
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 2
cd "$ROOT"
LEDGER="knowledge/verified-recipes.md"

hash_of() { sed 's/--.*$//' "$1" | tr '\n\t' '  ' | tr 'A-Z' 'a-z' | tr -s ' ' | sed 's/^ //; s/ $//' | shasum -a 256 | cut -c1-12; }

if [ "${1:-}" = "--hash" ]; then [ -f "${2:-}" ] || { echo "usage: scripts/recipe-check.sh --hash <file.sql>"; exit 2; }; hash_of "$2"; exit 0; fi

[ -f "$LEDGER" ] || { echo "✗ missing $LEDGER"; exit 2; }
bad=0; seen=0
# columns: | ID | Metric and scope | Query file | Hash | Golden | Origin | Status | Verified on |
rows="$(awk -F'|' '$2 ~ /^ *R-[0-9]+ *$/ { gsub(/^ +| +$/, "", $2); gsub(/^ +| +$/, "", $4); gsub(/^ +| +$/, "", $5); gsub(/^ +| +$/, "", $8); print $2 "\t" $4 "\t" $5 "\t" $8 }' "$LEDGER")"
while IFS="$(printf '\t')" read -r id file hash status; do
  [ -n "$id" ] || continue
  seen=$((seen + 1))
  file="$(printf '%s' "$file" | tr -d '`')"; hash="$(printf '%s' "$hash" | tr -d '`')"
  case "$file" in ""|"-"|"to pin"*) echo "• $id  no query pinned yet ($status)"; continue ;; esac
  if [ ! -f "$file" ]; then echo "✗ $id  MISSING query file: $file"; bad=1; continue; fi
  now="$(hash_of "$file")"
  if [ "$now" = "$hash" ]; then echo "✓ $id  hash matches ($status)"; else echo "✗ $id  STALE: $file changed since it was verified (ledger $hash, file $now) — status '$status' no longer holds"; bad=1; fi
done <<ROWS
$rows
ROWS
[ "$seen" -gt 0 ] || { echo "✗ no R- rows found in $LEDGER"; exit 2; }
exit $bad
