#!/usr/bin/env bash
# First-run setup for dd. Idempotent, non-blocking, self-skips after first run.
# Runs once per machine: environment checks, marketplace update-notifier hook
# install. GitHub star is opt-in via setup/star.sh (asked once, never automatic).
# Output is suppressed by the caller (Step 0).
set -uo pipefail

PLUGIN="dd"
OWN_REPO="fivetaku/dd"
HUB_REPO="fivetaku/gptaku_plugins"

CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
HERE="$(cd "$(dirname "$0")" && pwd)"
MARKER_DIR="$HOME/.gptaku-setup"
MARKER="$MARKER_DIR/$PLUGIN.json"
[ -f "$MARKER" ] && exit 0
mkdir -p "$MARKER_DIR"

# --- 1) Environment checks (silent, non-blocking; extend as needed) ---
HAVE_NODE=0; command -v node >/dev/null 2>&1 && HAVE_NODE=1
HAVE_GH=0;   command -v gh   >/dev/null 2>&1 && gh auth status >/dev/null 2>&1 && HAVE_GH=1

# --- 2) Marketplace update-notifier: install script + register SessionStart hook ---
# The actual update check runs later as a single SessionStart hook in settings.json;
# this only installs it (idempotent — skips if already present).
if [ "$HAVE_NODE" = "1" ]; then
  SCRIPTS_DIR="$CONFIG_DIR/scripts"
  mkdir -p "$SCRIPTS_DIR"
  [ -f "$HERE/gptaku-update-check.cjs" ] && cp -f "$HERE/gptaku-update-check.cjs" "$SCRIPTS_DIR/gptaku-update-check.cjs" 2>/dev/null
  CLAUDE_CONFIG_DIR="$CONFIG_DIR" node -e '
    const fs=require("fs"),path=require("path"),os=require("os");
    const cfg=process.env.CLAUDE_CONFIG_DIR||path.join(os.homedir(),".claude");
    const p=path.join(cfg,"settings.json");
    let d={}; try{d=JSON.parse(fs.readFileSync(p,"utf8"))}catch{}
    d.hooks=d.hooks||{};
    const ss=d.hooks.SessionStart=Array.isArray(d.hooks.SessionStart)?d.hooks.SessionStart:[];
    const has=ss.some(e=>((e&&e.hooks)||[]).some(h=>String((h&&h.command)||"").includes("gptaku-update-check")));
    if(!has){
      const cmd="node "+JSON.stringify(path.join(cfg,"scripts","gptaku-update-check.cjs"));
      ss.push({matcher:"*",hooks:[{type:"command",command:cmd,timeout:5}]});
      try{fs.writeFileSync(p,JSON.stringify(d,null,2))}catch{}
    }
  ' >/dev/null 2>&1 || true
fi

# --- 3) GitHub star: intentionally NOT done here.
#         Opt-in only — setup/star.sh runs after the user agrees via AskUserQuestion.

ts=$(date +%s 2>/dev/null || echo 0)
printf '{"setup":true,"plugin":"%s","ts":%s}\n' "$PLUGIN" "$ts" > "$MARKER"
exit 0
