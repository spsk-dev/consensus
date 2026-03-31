# SpSk Branded Output Reference — Consensus

This file defines the visual identity for consensus command output. Load via `@${CLAUDE_PLUGIN_ROOT}/shared/output.md`.

---

## Brand Header

The first output of every consensus command:

```
 ███████╗██████╗ ███████╗██╗  ██╗
 ██╔════╝██╔══██╗██╔════╝██║ ██╔╝
 ███████╗██████╔╝███████╗█████╔╝
 ╚════██║██╔═══╝ ╚════██║██╔═██╗
 ███████║██║     ███████║██║  ██╗
 ╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝
 consensus  v{version}  ───  {TYPE_LABEL}  ·  {model_config}
```

- **{version}**: read from `${CLAUDE_PLUGIN_ROOT}/VERSION`
- **{TYPE_LABEL}**: from type-profiles.json (e.g. "General", "Architecture", "Security")
- **{model_config}**: e.g. `opus+codex+gemini`, `opus+codex+sonnet`

---

## Score Display

Confidence scores are displayed on a 1-10 scale.

```
 Deep Verifier    (Opus)    8/10  Claims verified against codebase
 Devil's Advocate (Codex)   6/10  Found one unaddressed alternative
 Scope Analyst    (Gemini)  7/10  Second-order effects partially considered
```

Score bar (for consensus):
```
 Consensus: ████████░░ 7.0/10  MODERATE CONFIDENCE
```

Use `█` for filled segments, `░` for empty. 10 characters wide. Round to 1 decimal.

---

## Section Boxes

```
┌─────────────────────────────────────────────────────────────┐
│  SECTION TITLE                                              │
└─────────────────────────────────────────────────────────────┘
```

62-character wide boxes. Title in ALL CAPS. Content below, indented with single space.

---

## Verdict Display

```
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Consensus Confidence:  7.0/10  MODERATE CONFIDENCE
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Footer

```
github.com/spsk-dev/consensus
```
