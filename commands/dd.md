---
name: dd
description: Drop the current OS clipboard (text or image) into context and act on it — no pasting, no "look at my clipboard" boilerplate. Korean triggers: "클립보드 보내줘", "이거 분석해줘", "방금 캡처한 거", "이 레퍼런스로", "스크린샷 드롭". English triggers: "drop clipboard", "use what I copied", "this screenshot", "this reference".
argument-hint: "[request about the clipboard, optional]"
allowed-tools:
  - Bash
  - Read
---

<!-- first-run setup + star opt-in. AskUserQuestion must NOT be in frontmatter allowed-tools. -->
**Step 0 — run once at the very start, before anything else:** run `bash "${CLAUDE_PLUGIN_ROOT}/setup/setup.sh"`. If its output is exactly `STAR_ASK`, immediately call the **AskUserQuestion** tool once:
- header: `GitHub Star`
- question: `dd가 마음에 드시면 GitHub ⭐로 응원해주세요! (안 하셔도 모든 기능은 그대로 작동합니다.)`
- options: `네, ⭐ 눌러주기` / `아니요`

Then record the choice: `bash "${CLAUDE_PLUGIN_ROOT}/setup/setup.sh" star yes` for ⭐, or `bash "${CLAUDE_PLUGIN_ROOT}/setup/setup.sh" star no` for 아니요. If the output was empty, just continue silently. Do not narrate beyond the question itself.

# /dd — Drop clipboard into context

As your VERY FIRST action, before anything else, capture the current clipboard:

`python3 "${CLAUDE_PLUGIN_ROOT}/skills/dd/scripts/dd_clipboard.py" --json`

Then read the full policy and follow it:

Read `${CLAUDE_PLUGIN_ROOT}/skills/dd/SKILL.md`

The user's request about the clipboard (may be empty): $ARGUMENTS

Core rules (details in SKILL.md):

- If the manifest `ok` is false, show its `errors` to the user and STOP — the clipboard is empty or unsupported. Do not proceed with empty context.
- Show one short line of what was captured (kind / size / preview) so the user can catch a wrong or stale grab. The clipboard keeps only the most recent copy and has no timestamp.
- Confirm before acting ONLY when it looks wrong: the clipboard is unrelated to the request, or (no request) the conversation doesn't make the intent clear. Otherwise act directly — do not over-ask.
- Never paste the full clipboard content into chat. Read `content.txt` / `image.png` only as needed, following the manifest `size_class`.
