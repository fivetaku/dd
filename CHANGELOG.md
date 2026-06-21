# Changelog

## 0.4.0 — 2026-06-21

- GitHub star is now **opt-in**. First-run setup no longer stars the repos automatically; the command asks once via AskUserQuestion (둘 다 / 플러그인만 / 마켓플레이스만 / 아니요) and records the choice so it never asks again. Starring happens only after you agree.
- New `setup/star.sh` owns the star action (`--check` reports whether to ask; `both|own|hub|no` records the decision and stars accordingly). `setup/setup.sh` no longer touches GitHub stars.

## 0.2.2 — 2026-06-10

- Background sub-agents are now pinned to `model: sonnet` instead of inheriting the main session model — delegated work (summaries, error triage, visual briefs) doesn't need an expensive model. Validated against two buried-root-cause log scenarios.
- Error/log diagnosis delegation now includes first-anomaly guidance (find what changed right before the first anomaly — deploys, config reloads, flag flips — and treat the tail error flood as a consequence). This was the difference between symptom-level and root-cause diagnoses in testing.

## 0.2.1 — 2026-06-07

- Language: reply in the language of the request; with no request, reply in the language of the ongoing conversation. No hardcoded default and nothing stored — the language is inferred fresh each time. A fresh session's bare `/dd` with no context falls back to English.

## 0.2.0 — 2026-06-06

- Background analysis routing: for analyze-and-report tasks (summarize, explain, "what is this") on large text or an image, dd delegates the read to a background subagent and returns only the conclusion, so the raw content and images stay out of the main conversation. Tasks that work with the content (fix, build, iterate) still read in-session.

## 0.1.0 — 2026-06-06

Initial release.

- `/dd` and `/ㅇㅇ` capture the current OS clipboard (text or image) into `~/dd/` and act on it, injecting only a short manifest summary instead of dumping the raw content into the conversation.
- Hangul-jamo alias `/ㅇㅇ` — typing `dd` in a Korean IME produces `ㅇㅇ`, no language switch needed.
- Clipboard capture on macOS / Windows / WSL / Linux (macOS + Windows verified).
- Image **file** resolution: copying an image file in Finder/Explorer captures the real picture, not its icon (macOS `furl`, Windows `GetFileDropList`).
- Secret redaction in previews (`api_key`, `Bearer`, `sk-`, `ghp_`, `xoxb-`, AWS, JWT, Google, GitLab, …).
- Lazy reading by text `size_class`; confirm gate for empty / stale / mismatched clipboards.
- `0700`/`0600` cache permissions, atomic manifest writes, streaming hashes, 7-day auto-cleanup.
