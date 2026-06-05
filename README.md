English | [한국어](README.ko.md)

# dd

> Hand Claude Code a long log or a screenshot without pasting it into the chat.

Working in Claude Code, you paste a lot: error logs when something breaks, a reference when you're building, a screenshot to show what you want. `dd` reads that straight off the clipboard, keeps it in a local file, and gives Claude only a short, secret-redacted summary.

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

### 4. Use it

Put something on your clipboard, then type `/dd` (or `/ㅇㅇ`) with your request — no pasting needed:

- **Image — Windows:** capture with `Win`+`Shift`+`S`, then `/dd 왜 이렇게 보여?` (the snip is already on the clipboard)
- **Image — macOS:** capture with `Ctrl`+`Shift`+`Cmd`+`4` — the `Ctrl` sends it to the clipboard instead of saving a file — then `/dd 이 레퍼런스처럼 만들어줘`
- **Long text / error log:** copy it, then `/dd 무슨 에러야?` — it never lands in the chat as a wall of text, so the session stays small
- **No request:** just `/dd` — it reads the clipboard and continues from the conversation

> **macOS tip:** to make a plain `Shift`+`Cmd`+`4` always go to the clipboard, open the screenshot toolbar (`Shift`+`Cmd`+`5`) → **Options** → **Save to: Clipboard**. Then you can skip the `Ctrl`.

In a Korean IME you can type `/dd` as-is — it comes out as `/ㅇㅇ`, same thing. No language switching.

---

## Why dd?

Working in Claude Code, you paste all the time. An error log when something breaks, a reference when you're building, a screenshot to show the look you're after. Pasting it all straight into the chat runs into two problems.

Long text eats the conversation. Drop a big log in once and it stays there, taking up room and getting re-read every turn, so the session slowly gets slower and pricier. `dd` keeps the full text in a file, hands Claude a short summary, and reads more only when the task needs it.

Images often won't paste at all. Depending on your setup, Claude Code may not take a pasted image. `dd` reads the clipboard directly, so you just capture and type `/dd`. A copied image file comes in as the real picture, not its icon.

You also stop repeating yourself: no "the error I just copied" or "the reference above." And if `dd` grabs the wrong thing (the clipboard has no timestamp), it shows what it got and asks first.

The name `dd` doesn't stand for anything. You reach for it often and typing something long every time is a pain, so it's just two quick taps. (In a Korean IME those same keys come out as `ㅇㅇ`, which works the same.)

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

Copy something, then `/dd`.

</div>
