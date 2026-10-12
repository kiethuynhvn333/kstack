#!/usr/bin/env sh
# Update the KStack files that ship with the template, from the public repo. Never touches your data.
#
#   sh scripts/update.sh              preview what changes, ask, then apply (latest main)
#   sh scripts/update.sh v0.3.0       a tagged release instead of main
#   sh scripts/update.sh --yes        apply without asking (for an agent you trust to run it)
#   sh scripts/update.sh --migrate    only the one-time v0.3 → v0.4 layout upgrade (run it if an older update.sh
#                                     just installed v0.4; works on top of that uncommitted update)
#
# Updates: AGENTS.md, tool entry files, CHANGELOG.md, rules/, skills/, scripts/, projects/_template/
#   (overwrites the shipped files of the same name; your own extra skills and rules are left alone,
#   and per AGENTS.md you never edit the shipped ones — your preferences live in profile.md / workspace.md).
# Adds: new files under knowledge/ and new *.example.md files.
# Lists, never overwrites: knowledge/ files that exist on both sides — you may have edited them.
# Never touches: profile.md, workspace.md, your worklogs and tracking rows, your own knowledge content.
# Upgrading from v0.3 (one-time, shown and asked first): moves your knowledge/{metrics,verification,
#   verified-recipes}.md and checks/ into knowledge/measurement/ (your edits kept), carries every row of each
#   segment's mistakes-and-learnings.md into that segment's new knowledge.md → Traps (same columns), adds a
#   README.md to projects that lack one, and moves the retired files (inbox, mistakes files) to archive/.
# Does not commit. Needs a clean working tree so the update is one easy-to-undo change.
set -eu

URL="${KSTACK_URL:-https://github.com/kiethuynhvn333/kstack.git}"
REMOTE=kstack
ENGINE="AGENTS.md CLAUDE.md GEMINI.md CHANGELOG.md .claude rules skills scripts projects/_template"
SHARED="knowledge profile.example.md workspace.example.md"

# --- v0.3 -> v0.4 migration (knowledge captured at session end; project knowledge inside projects) ---
plan_migration() {
  for f in metrics verification verified-recipes; do
    [ -f "knowledge/$f.md" ] && [ ! -f "knowledge/measurement/$f.md" ] && echo "  move knowledge/$f.md → knowledge/measurement/$f.md"
  done
  [ -d knowledge/checks ] && [ ! -d knowledge/measurement/checks ] && echo "  move knowledge/checks/ → knowledge/measurement/checks/"
  [ -f knowledge/meta/inbox.md ] && echo "  archive knowledge/meta/inbox.md → archive/v0.3-retired/knowledge-inbox.md ($(grep -c '^| K-' knowledge/meta/inbox.md || true) rows to re-file)"
  for p in projects/*/; do
    p="${p%/}"; [ "$(basename "$p")" = "_template" ] && continue
    [ -f "$p/README.md" ] || echo "  add $p/README.md (project brief template — fill it in)"
    for m in "$p"/*/mistakes-and-learnings.md; do
      [ -f "$m" ] || continue
      echo "  $(dirname "$m")/: mistakes-and-learnings.md ($(grep -c '^| C-' "$m" || true) rows) → knowledge.md Traps; old file → archive/v0.3-retired/"
    done
  done
  return 0
}

migrate() {
  target="$1"; today="$(date +%Y-%m-%d)"; arch=archive/v0.3-retired
  mkdir -p knowledge/measurement "$arch"
  for f in metrics verification verified-recipes; do
    if [ -f "knowledge/$f.md" ] && [ ! -f "knowledge/measurement/$f.md" ]; then git mv "knowledge/$f.md" "knowledge/measurement/$f.md"; fi
  done
  if [ -d knowledge/checks ] && [ ! -d knowledge/measurement/checks ]; then git mv knowledge/checks knowledge/measurement/checks; fi
  if [ -f knowledge/meta/inbox.md ]; then
    n="$(grep -c '^| K-' knowledge/meta/inbox.md || true)"
    git mv knowledge/meta/inbox.md "$arch/knowledge-inbox.md"
    [ "$n" -gt 0 ] && echo "  ! $n inbox rows are in $arch/knowledge-inbox.md. Ask your agent to file each one:" \
      "fixed knowledge → the segment's knowledge.md, unproven → experiments.md as a Hypothesis row, or drop it."
  fi
  for p in projects/*/; do
    p="${p%/}"; name="$(basename "$p")"; [ "$name" = "_template" ] && continue
    if [ ! -f "$p/README.md" ]; then
      git show "$target:projects/_template/README.md" | sed "s/<Project name>/$name/" > "$p/README.md"
      echo "  ! $p/README.md added from the template — ask your agent to fill in the brief."
    fi
    for m in "$p"/*/mistakes-and-learnings.md; do
      [ -f "$m" ] || continue
      s="$(dirname "$m")"; seg="$(basename "$s")"; k="$s/knowledge.md"
      if [ ! -f "$k" ]; then
        git show "$target:projects/_template/_segment/knowledge.md" \
          | sed "s/<Project>/$name/; s/<segment>/$seg/; s/<YYYY-MM-DD>/$today/" > "$k"
      fi
      rows="$(grep '^| C-' "$m" || true)"
      if [ -n "$rows" ]; then
        printf '%s\n' "$rows" > "$k.rows"
        awk -v rf="$k.rows" '/^\| _none yet_ \|/ && !done { while ((getline l < rf) > 0) print l; done=1; next } { print }' "$k" > "$k.tmp"
        grep -q '^| C-' "$k.tmp" || { cat "$k.rows" >> "$k.tmp"; }   # no placeholder row: append at the end
        mv "$k.tmp" "$k"; rm -f "$k.rows"
      fi
      git mv "$m" "$arch/$name-$seg-mistakes-and-learnings.md"
    done
  done
  # shipped template file retired in v0.4 (not user data)
  if [ -f projects/_template/_segment/mistakes-and-learnings.md ]; then git rm -q projects/_template/_segment/mistakes-and-learnings.md; fi
  echo "  Migration done: none of your content deleted; retired files are in $arch/."
}

main() {
  yes=0; ref=main; only_migrate=0
  for a in "$@"; do case "$a" in --yes) yes=1 ;; --migrate) only_migrate=1 ;; *) ref="$a" ;; esac; done

  root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "✗ This folder is not a git repo. Use your private repo made from the template."; return 1; }
  cd "$root"
  if [ "$only_migrate" -ne 1 ] && [ -n "$(git status --porcelain)" ]; then
    echo "✗ You have uncommitted changes. Commit or stash them first, so the update is easy to undo."; return 1
  fi

  git remote get-url "$REMOTE" >/dev/null 2>&1 || git remote add "$REMOTE" "$URL"
  git fetch -q "$REMOTE" --tags
  if git rev-parse -q --verify "refs/remotes/$REMOTE/$ref^{commit}" >/dev/null; then target="refs/remotes/$REMOTE/$ref"
  elif git rev-parse -q --verify "refs/tags/$ref^{commit}" >/dev/null; then target="refs/tags/$ref"
  else echo "✗ '$ref' is not a branch or tag of $(git remote get-url "$REMOTE")"; return 1; fi

  plan="$(plan_migration)"
  if [ -n "$plan" ]; then
    echo "This workspace uses the v0.3 layout. One-time upgrade to v0.4 (see CHANGELOG.md):"
    echo "$plan"
    if [ "$yes" -ne 1 ]; then
      [ -t 0 ] || { echo "✗ Not interactive. Re-run with --yes to apply."; return 1; }
      printf 'Upgrade the layout now? [y/N] '; read -r ans || ans=n
      case "$ans" in y|Y|yes) ;; *) echo "Nothing changed."; return 0 ;; esac
    fi
    migrate "$target"
    echo
  fi
  if [ "$only_migrate" -eq 1 ]; then
    [ -n "$plan" ] || echo "✓ Layout is already v0.4 — nothing to migrate."
    if sh scripts/validate.sh; then rc=0; else rc=1; fi
    echo; echo "Nothing is committed. Review with 'git status', then commit the update."
    return "$rc"
  fi

  paths=""
  for p in $ENGINE; do git cat-file -e "$target:$p" 2>/dev/null && paths="$paths $p"; done
  engine_files="$(git diff --name-only --diff-filter=AM HEAD "$target" -- $paths)"
  new_shared="$(git diff --name-only --diff-filter=A HEAD "$target" -- $SHARED)"
  both_shared="$(git diff --name-only --diff-filter=M HEAD "$target" -- $SHARED)"
  # a "new" shared file that is already on disk (e.g. moved there by the migration) holds your content:
  # list it for a hand merge instead of overwriting it
  keep=""; for f in $new_shared; do
    if [ -e "$f" ]; then both_shared="$(printf '%s\n%s' "$both_shared" "$f")"; else keep="$(printf '%s\n%s' "$keep" "$f")"; fi
  done
  new_shared="$(printf '%s\n' "$keep" | sed '/^$/d')"; both_shared="$(printf '%s\n' "$both_shared" | sed '/^$/d')"

  echo "Updating from $(git remote get-url "$REMOTE") → $ref ($(git rev-parse --short "$target"))"
  if [ -z "$engine_files" ] && [ -z "$new_shared" ]; then
    echo "✓ Shipped files are already up to date."
  else
    echo; echo "Will overwrite or add:"
    printf '%s\n%s\n' "$engine_files" "$new_shared" | sed '/^$/d; s/^/  /'
    if [ "$yes" -ne 1 ]; then
      [ -t 0 ] || { echo "✗ Not interactive. Re-run with --yes to apply."; return 1; }
      printf 'Apply? [y/N] '; read -r ans || ans=n
      case "$ans" in y|Y|yes) ;; *) echo "Nothing changed."; return 0 ;; esac
    fi
    printf '%s\n%s\n' "$engine_files" "$new_shared" | sed '/^$/d' | while IFS= read -r f; do
      git checkout -q "$target" -- "$f"
    done
  fi

  if [ -n "$both_shared" ]; then
    echo; echo "These knowledge/example files exist in both versions and may hold your own edits."
    echo "Not changed. Compare and merge by hand, or ask your agent to (keep your content):"
    echo "$both_shared" | sed 's/^/  /'
    echo "  See what changed:  git diff HEAD $target -- <file>"
  fi

  echo; echo "Now at: $(sed -n '/^## /{p;q;}' CHANGELOG.md 2>/dev/null || echo 'unknown')"
  if sh scripts/validate.sh; then rc=0; else rc=1; fi
  echo; echo "Nothing is committed. Review with 'git status', then commit the update."
  return "$rc"
}

main "$@"
exit $?
