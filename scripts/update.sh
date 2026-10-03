#!/usr/bin/env sh
# Update the KStack files that ship with the template, from the public repo. Never touches your data.
#
#   sh scripts/update.sh              preview what changes, ask, then apply (latest main)
#   sh scripts/update.sh v0.3.0       a tagged release instead of main
#   sh scripts/update.sh --yes        apply without asking (for an agent you trust to run it)
#
# Updates: AGENTS.md, tool entry files, CHANGELOG.md, rules/, skills/, scripts/, projects/_template/
#   (overwrites the shipped files of the same name; your own extra skills and rules are left alone,
#   and per AGENTS.md you never edit the shipped ones — your preferences live in profile.md / workspace.md).
# Adds: new files under knowledge/ and new *.example.md files.
# Lists, never overwrites: knowledge/ files that exist on both sides — you may have edited them.
# Never touches: profile.md, workspace.md, projects/<your projects>/, archive/, your own knowledge.
# Does not commit. Needs a clean working tree so the update is one easy-to-undo change.
set -eu

URL="${KSTACK_URL:-https://github.com/kiethuynhvn333/kstack.git}"
REMOTE=kstack
ENGINE="AGENTS.md CLAUDE.md GEMINI.md CHANGELOG.md .claude rules skills scripts projects/_template"
SHARED="knowledge profile.example.md workspace.example.md"

main() {
  yes=0; ref=main
  for a in "$@"; do case "$a" in --yes) yes=1 ;; *) ref="$a" ;; esac; done

  root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "✗ This folder is not a git repo. Use your private repo made from the template."; return 1; }
  cd "$root"
  if [ -n "$(git status --porcelain)" ]; then
    echo "✗ You have uncommitted changes. Commit or stash them first, so the update is easy to undo."; return 1
  fi

  git remote get-url "$REMOTE" >/dev/null 2>&1 || git remote add "$REMOTE" "$URL"
  git fetch -q "$REMOTE" --tags
  if git rev-parse -q --verify "refs/remotes/$REMOTE/$ref^{commit}" >/dev/null; then target="refs/remotes/$REMOTE/$ref"
  elif git rev-parse -q --verify "refs/tags/$ref^{commit}" >/dev/null; then target="refs/tags/$ref"
  else echo "✗ '$ref' is not a branch or tag of $(git remote get-url "$REMOTE")"; return 1; fi

  paths=""
  for p in $ENGINE; do git cat-file -e "$target:$p" 2>/dev/null && paths="$paths $p"; done
  engine_files="$(git diff --name-only --diff-filter=AM HEAD "$target" -- $paths)"
  new_shared="$(git diff --name-only --diff-filter=A HEAD "$target" -- $SHARED)"
  both_shared="$(git diff --name-only --diff-filter=M HEAD "$target" -- $SHARED)"

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
