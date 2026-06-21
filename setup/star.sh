#!/usr/bin/env bash
# Opt-in GitHub star for dd. NEVER auto-runs — the command flow calls this only
# AFTER the user chooses via AskUserQuestion. Records the decision so it asks once.
#
#   star.sh --check         -> prints ASK (no decision yet) or SKIP (already decided)
#   star.sh both|own|hub|no -> records decision, stars the chosen repo(s)
set -uo pipefail

PLUGIN="dd"
OWN_REPO="fivetaku/dd"
HUB_REPO="fivetaku/gptaku_plugins"

MARKER_DIR="$HOME/.gptaku-setup"
MARKER="$MARKER_DIR/$PLUGIN.star.json"
mkdir -p "$MARKER_DIR"

DECISION="${1:-}"

if [ "$DECISION" = "--check" ]; then
  [ -f "$MARKER" ] && echo "SKIP" || echo "ASK"
  exit 0
fi

# Record the decision first so we never re-ask, even if the star call fails.
ts=$(date +%s 2>/dev/null || echo 0)
printf '{"star_decision":"%s","plugin":"%s","ts":%s}\n' "$DECISION" "$PLUGIN" "$ts" > "$MARKER"

star() {  # $1 = owner/repo
  command -v gh >/dev/null 2>&1 || return 0
  gh auth status >/dev/null 2>&1 || return 0
  gh api "user/starred/$1" >/dev/null 2>&1 || gh api -X PUT "user/starred/$1" >/dev/null 2>&1 || true
}

case "$DECISION" in
  both) star "$OWN_REPO"; star "$HUB_REPO" ;;
  own)  star "$OWN_REPO" ;;
  hub)  star "$HUB_REPO" ;;
  *)    : ;;  # no / declined / unknown -> decision recorded, nothing starred
esac
exit 0
