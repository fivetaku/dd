English | [한국어](README.ko.md)

# dd

> **Stop saying "look at my clipboard." Just `/dd`.**

`dd` drops whatever is on your clipboard right now — a screenshot, a design reference, an error log, a code snippet — straight into Claude Code, and acts on it. No pasting, no "use the image I just copied" boilerplate. The raw content stays in a local file; only a short summary enters the conversation.

[Quick Start](#quick-start) • [Why dd?](#why-dd) • [How it works](#how-it-works) • [Features](#features) • [Commands](#commands) • [Requirements](#requirements)

---

## Quick Start

### 1. Add the marketplace

```
/plugin marketplace add https://github.com/fivetaku/gptaku_plugins.git
```

### 2. Install

```
/plugin install dd
```

### 3. Restart Claude Code

(New commands only register after a restart.)

### 4. Run

Copy something or take a screenshot, then:

```
/dd 이런 느낌으로 만들어줘
/dd 왜 깨져?
/dd            (no request — dd reads the clipboard and continues from the conversation)
```

In a Korean IME you can type `/dd` as-is — it comes out as `/ㅇㅇ`, which does the same thing. No language switching.

---

## Why dd?

- **Terminal Claude Code can't paste images.** Normally you'd save the screenshot to a file, find the path, and say "look at this file." `dd` automates exactly that: clipboard image → saved file → Claude sees it.
- **No boilerplate.** You stop writing "the error I just copied" or "the reference image above." Just `/dd` and your request.
- **Clean context.** The full text/image lives in `~/dd/`; only a manifest and a short, secret-redacted preview enter the chat.
- **Catches stale grabs.** The clipboard has no timestamp, so `dd` shows what it captured and asks before acting when the content looks unrelated to your request.

---

## How it works

```
copy / screenshot
   → /dd [request]
   → dd_clipboard.py captures the current clipboard into ~/dd/<date>/<id>/
       · text → content.txt   image → image.png   + manifest.json
   → Claude reads the manifest summary (not the full content)
   → shows what it grabbed; confirms if it looks wrong; otherwise acts
```

The OS clipboard holds only the most recent copy (no history). `dd` always captures that current item, redacts secrets from the preview, and cleans up captures older than 7 days.

---

## Features

| Feature | Description |
|---------|-------------|
| Text & image capture | macOS / Windows / WSL / Linux clipboard, text or image |
| Instruction-pattern injection | Captures on every `/dd` via `${CLAUDE_PLUGIN_ROOT}` — works for everyone |
| Confirm gate | Asks before acting only when the clipboard looks unrelated or ambiguous |
| Lazy reading | Reads by `size_class` so a huge paste never floods context |
| Secret redaction | `api_key`, `Bearer`, `sk-`, `ghp_`, `xoxb-`, etc. masked in preview |
| Auto cleanup | Captures older than `DD_RETENTION_DAYS` (default 7) deleted on each run |

---

## Commands

| Command | Description |
|---------|-------------|
| `/dd [request]` | Capture the current clipboard and act on it |
| `/ㅇㅇ [request]` | Same as `/dd` (Hangul-mode alias) |

### Natural language triggers

- "방금 캡처한 거 분석해줘", "이 레퍼런스로 만들어줘", "스크린샷 드롭"
- "drop clipboard", "use what I copied", "this screenshot"

---

## Requirements

- [Claude Code](https://docs.anthropic.com/claude-code) CLI
- Python 3 (standard library only)
- **macOS**: works out of the box (`pbpaste` / `osascript`)
- **Windows / WSL**: PowerShell (built in) — user-verified
- **Linux**: a clipboard tool installed (`xclip` / `wl-clipboard`) and a graphical session

---

## License

MIT

---

<div align="center">

**Copy it. `/dd` it. Done.**

</div>
