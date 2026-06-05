# Changelog

## 0.1.0 — 2026-06-06

Initial release.

- `/dd` and `/ㅇㅇ` capture the current OS clipboard (text or image) into `~/dd/` and act on it, injecting only a short manifest summary instead of dumping the raw content into the conversation.
- Hangul-jamo alias `/ㅇㅇ` — typing `dd` in a Korean IME produces `ㅇㅇ`, no language switch needed.
- Clipboard capture on macOS / Windows / WSL / Linux (macOS + Windows verified).
- Image **file** resolution: copying an image file in Finder/Explorer captures the real picture, not its icon (macOS `furl`, Windows `GetFileDropList`).
- Secret redaction in previews (`api_key`, `Bearer`, `sk-`, `ghp_`, `xoxb-`, AWS, JWT, Google, GitLab, …).
- Lazy reading by text `size_class`; confirm gate for empty / stale / mismatched clipboards.
- `0700`/`0600` cache permissions, atomic manifest writes, streaming hashes, 7-day auto-cleanup.
