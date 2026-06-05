---
name: dd
description: This skill should be used when the user runs /dd or /ㅇㅇ to act on the current OS clipboard (text or image) without pasting it into chat. It captures the live clipboard into a local cache and uses only the manifest plus a short preview as context, so error logs and reference images do not bloat the conversation. Korean triggers: "/dd", "/ㅇㅇ", "클립보드 보내줘", "이거 분석해줘", "방금 캡처한 거", "이 레퍼런스로", "스크린샷 드롭". English triggers: "/dd", "drop clipboard", "use what I copied", "this screenshot", "this reference".
---

# dd — Drop clipboard into context

> Capture the current OS clipboard and act on it, without pasting raw content into chat.

The user copied or screenshotted something — usually a design reference or screenshot, sometimes an error log, code, or URL — and wants it used as the reference for their request. `/dd` and `/ㅇㅇ` capture the live clipboard into `~/dd/` and inject only a manifest summary, keeping the conversation clean.

## Workflow

### Step 1 — Capture (always first)
**Type**: script
The command runs `python3 "${CLAUDE_PLUGIN_ROOT}/skills/dd/scripts/dd_clipboard.py" --json` as its first action. It writes the clipboard to `~/dd/<date>/<id>/` and prints a manifest: `ok`, `primary` (`kind`, `path`, `size_class`, `preview`, `oversized`), `items`, `errors`, `captured_at`, `platform`.

### Step 2 — Empty / failure gate
**Type**: review
Check `ok` first. If it is false, show the `errors[]` to the user verbatim and STOP. The clipboard is empty or unsupported — do not proceed with empty context or invent content. Example reply: "클립보드가 비어있어요. 복사하고 다시 /dd 해주세요." This matters because the clipboard usually holds *something*; a true empty is rare, so a real `ok:false` is worth surfacing.

### Step 3 — Show what was captured
**Type**: prompt
Show one short line so the user can confirm it is the intended item:
- text → `kind`, `size_class`, the first ~2 lines of `preview`
- image → `image, <KB>, saved to <path>`
The clipboard keeps only the most recent copy and has no history or timestamp, so an item copied long ago can still be sitting there. This one line is the user's only chance to catch a stale or wrong grab.

### Step 4 — Confirm gate (only when it looks wrong)
**Type**: review
Judge whether the captured item matches intent, then:
- Request present (`$ARGUMENTS` non-empty) but the clipboard is clearly unrelated to it → ask "클립보드에 <요약> 있는데, 이거 맞아요?" before acting.
- No request and you cannot tell from the ongoing conversation what to do with it → ask the same.
- Otherwise (it clearly fits the request, or fits what the conversation is already doing) → act directly, do not ask.
Confirm with a normal question in your reply, not a tool. Do not over-ask: gate only on a real mismatch, since asking every time is annoying.

### Step 5 — Read by size (text)
**Type**: prompt
Lead with the manifest `preview`. Read the file only as needed so a huge paste never floods context:
- `small` → answer from `preview`; do not open the file.
- `medium` → use `rg`/`head`/`tail` on `content.txt`; avoid a full read.
- `large` → read focused ranges; write `summary.md` only if the request truly needs a summary or the same capture is reused.
- `huge` → never read the whole file; search with `rg` for error keywords and read head/tail only.
Never paste the full content into chat.

### Step 6 — Images
**Type**: prompt
For `kind: image`, Read the saved `image.png` to actually see it, then act on the request (e.g. "이런 느낌으로 만들어줘", "왜 깨져?"). Do not create an automatic summary for images. If `oversized` is true, avoid a full read — describe from metadata or ask the user to crop the area that matters.

### Step 7 — Intent inference (no request)
**Type**: prompt
If `$ARGUMENTS` is empty, infer the task from the content AND the ongoing conversation, then state the inferred intent in one line BEFORE acting ("📋 에러 로그 감지 → 원인부터 볼게요"), so the user can redirect. Mapping: error/traceback → debug, code → explain/review, broken-UI image → diagnose, URL/doc → summarize. If it is still ambiguous after considering the conversation, fall back to the Step 4 confirm rather than guessing.

## Why this shape
The clipboard is a single most-recent slot with no timestamp, so freshness cannot be measured — only judged by whether the content fits the intent (Steps 3–4). Reading lazily by `size_class` (Step 5) keeps token cost low, which is a side benefit; the main job is simply handing the clipboard to Claude.

## Security
- The script redacts `api_key`/`token`/`password`/`Bearer`/`sk-`/`ghp_`/`xoxb-` patterns in the preview. The raw file on disk is not redacted, so do not echo full raw content back unnecessarily.
- The cache lives in `~/dd/` and auto-deletes captures older than `DD_RETENTION_DAYS` (default 7) on each run. Nothing is uploaded anywhere.

## Scripts
- **`scripts/dd_clipboard.py`** — captures the clipboard, writes the cache and manifest, computes the text size class, redacts the preview, flags oversized images, and cleans up old captures. Run with `--json`. Environment: `DD_CACHE_DIR` (default `~/dd`), `DD_RETENTION_DAYS`, `DD_PREVIEW_LINES`, `DD_MAX_PREVIEW_CHARS`.
