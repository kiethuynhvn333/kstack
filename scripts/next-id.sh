#!/usr/bin/env sh
# Print the next free ID for a prefix. IDs are one sequence for the whole repo (rule 43):
# every mention in projects/, knowledge/, skills/ and archive/ counts, so a number is never reused.
#
#   scripts/next-id.sh D   # decision        -> e.g. D-012
#   scripts/next-id.sh O   # open item
#   scripts/next-id.sh E   # experiment
#   scripts/next-id.sh E   # (also a Hypothesis row in experiments.md)
#   scripts/next-id.sh C   # trap (a mistake or conflicting sources) in a segment's knowledge.md
# K- (the old knowledge inbox) was retired in v0.4; old K- IDs stay valid in archive/.
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$ROOT"

p="${1:-}"
case "$p" in
  D|O|E|C) ;;
  K) echo "K- (knowledge inbox) is retired since v0.4: fixed knowledge goes to a segment's knowledge.md, unproven to experiments.md (E-)." >&2; exit 1 ;;
  *) echo "usage: scripts/next-id.sh D|O|E|C  (D=decision O=open item E=experiment/hypothesis C=trap)" >&2; exit 1 ;;
esac

dirs=""
for d in projects knowledge skills archive; do
  test -d "$d" && dirs="$dirs $d"
done

max=0
if test -n "$dirs"; then
  # Word-bounded, so codes like "ABC-123" or hashes don't count. The template has no IDs.
  # shellcheck disable=SC2086
  found="$(grep -rIhoE "(^|[^A-Za-z0-9_-])${p}-[0-9]{3,}([^0-9]|$)" --exclude-dir=_template $dirs 2>/dev/null \
    | grep -oE "${p}-[0-9]+" | sed "s/^${p}-//" | sort -n | tail -1 || true)"
  test -n "$found" && max="$found"
fi

awk -v p="$p" -v m="$max" 'BEGIN { printf "%s-%03d\n", p, m + 1 }'
