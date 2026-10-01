#!/usr/bin/env sh
# Static smell test for SQL, built from past wrong-number incidents. Not proof a query is right:
# it only catches known traps by text pattern. Usage:
#   scripts/sql-lint.sh query.sql [more.sql]   exit 1 if any FAIL rule fires (WARN never fails)
#   scripts/sql-lint.sh --selftest             every rule must fire on its bad fixture and stay silent on its
#                                   good one, and the lint-allow marker must behave (negative controls)
#
# A deliberate exception is written in the query itself, with a reason, and only with the user's OK:
#   -- lint-allow: L004 company-wide total on purpose, report says "all stores"
# The lint then prints ALLOWED + the reason instead of FAIL, so the exception stays visible.
# A marker with no reason (under 8 characters) is ignored and the rule still fires.
set -eu
DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
RULES="$DIR/sql-lint/rules.tsv"
FIX="$DIR/sql-lint/fixtures"

norm() { sed 's/--.*$//' "$1" | tr '\n\t' '  ' | tr 'A-Z' 'a-z' | tr -s ' '; }
field() { printf '%s\n' "$1" | cut -f"$2"; }

# fires <rule-line> <file>  -> 0 if the rule fires on the file
fires() {
  when="$(field "$1" 3)"; also="$(field "$1" 4)"; unless="$(field "$1" 5)"
  text="$(norm "$2")"
  printf '%s' "$text" | grep -Eq -- "$when" || return 1
  if [ -n "$also" ]; then printf '%s' "$text" | grep -Eq -- "$also" || return 1; fi
  if [ -n "$unless" ]; then printf '%s' "$text" | grep -Eq -- "$unless" && return 1; fi
  return 0
}

# allow_reason <file> <rule-id> -> prints the reason text of the first matching lint-allow line
allow_reason() {
  grep -iE "^[[:space:]]*--[[:space:]]*lint-allow:[[:space:]]*$2([[:space:]]|$)" "$1" | head -1 \
    | sed -E "s/^[[:space:]]*--[[:space:]]*[Ll][Ii][Nn][Tt]-[Aa][Ll][Ll][Oo][Ww]:[[:space:]]*[A-Za-z0-9]+[[:space:]]*//; s/[[:space:]]+$//" || true
}
has_marker() { grep -iqE "^[[:space:]]*--[[:space:]]*lint-allow:[[:space:]]*$2([[:space:]]|$)" "$1"; }

rule_lines() { grep -v '^#' "$RULES" | grep -v '^[[:space:]]*$'; }

if [ "${1:-}" = "--selftest" ]; then
  problems="$(mktemp)"; tmp="$(mktemp -d)"; trap 'rm -f "$problems"; rm -rf "$tmp"' EXIT
  rule_lines | while IFS= read -r line; do
    id="$(field "$line" 1)"
    for kind in bad good; do
      f="$FIX/$id.$kind.sql"
      [ -f "$f" ] || { echo "✗ $id: missing fixture $f"; echo x >> "$problems"; continue; }
      if fires "$line" "$f"; then hit=1; else hit=0; fi
      if [ "$kind" = bad ] && [ "$hit" = 0 ]; then echo "✗ $id did NOT fire on its bad fixture"; echo x >> "$problems"; fi
      if [ "$kind" = good ] && [ "$hit" = 1 ]; then echo "✗ $id fired on its good fixture"; echo x >> "$problems"; fi
    done
  done
  # lint-allow: with a reason, every FAIL rule's bad fixture must stop failing; without one it must still fail
  fail_id="$(rule_lines | awk -F'\t' '$2 == "FAIL" { print $1; exit }')"
  if [ -n "$fail_id" ]; then
    { rule_lines | awk -F'\t' '$2 == "FAIL" { print "-- lint-allow: " $1 " selftest reason, deliberate" }'; cat "$FIX/$fail_id.bad.sql"; } > "$tmp/allow-ok.sql"
    { echo "-- lint-allow: $fail_id"; cat "$FIX/$fail_id.bad.sql"; } > "$tmp/allow-noreason.sql"
    sh "$0" "$tmp/allow-ok.sql" >/dev/null 2>&1 || { echo "✗ lint-allow with a reason did not downgrade FAIL to ALLOWED"; echo x >> "$problems"; }
    sh "$0" "$tmp/allow-ok.sql" 2>&1 | grep -q '^ALLOWED' || { echo "✗ lint-allow did not print ALLOWED"; echo x >> "$problems"; }
    if sh "$0" "$tmp/allow-noreason.sql" >/dev/null 2>&1; then echo "✗ lint-allow WITHOUT a reason was accepted"; echo x >> "$problems"; fi
  fi
  if [ -s "$problems" ]; then exit 1; fi
  echo "✓ sql-lint selftest passed ($(rule_lines | wc -l | tr -d ' ') rules: bad fires / good silent; lint-allow needs a reason)"
  exit 0
fi

[ $# -ge 1 ] || { echo "usage: scripts/sql-lint.sh <file.sql>... | --selftest"; exit 2; }
status=0
for f in "$@"; do
  [ -f "$f" ] || { echo "✗ not a file: $f"; exit 2; }
  hits=0
  while IFS= read -r line; do
    if fires "$line" "$f"; then
      hits=$((hits + 1))
      id="$(field "$line" 1)"; sev="$(field "$line" 2)"; msg="$(field "$line" 6)"
      if has_marker "$f" "$id"; then
        reason="$(allow_reason "$f" "$id")"
        if [ "${#reason}" -ge 8 ]; then
          echo "ALLOWED $id $f — reason given: $reason  [rule was: $msg]"
          continue
        fi
        echo "• lint-allow for $id ignored: it needs a reason of at least 8 characters"
      fi
      echo "$sev $id $f — $msg [$(field "$line" 7)]"
      [ "$sev" = FAIL ] && status=1
    fi
  done <<RULES
$(rule_lines)
RULES
  [ "$hits" -gt 0 ] || echo "✓ $f — no known trap matched (this is a smell test, not proof)"
done
exit $status
