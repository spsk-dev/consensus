# Changelog

All notable changes to the SpSk consensus plugin.

## [2.2.0] - 2026-04-28

### Changed

- **Best-models policy enforced.** Consensus is high-leverage, not high-volume — always use thinking models, never speed-tier defaults.
  - Codex: `codex exec --full-auto --effort high` (was `--full-auto` only — defaulted to mid-tier reasoning).
  - Gemini: `gemini -y -m gemini-2.5-pro -p ...` (was `gemini -y -p ...` — defaulted to `gemini-3-flash-preview` which routinely 429s with `MODEL_CAPACITY_EXHAUSTED` on shared cloudcode-pa OAuth).
  - Claude: Opus already specified.

### Added

- **Spawn-context preambles** on Codex and Gemini dispatches (HOW spawning + COMMON PROBLEMS + WHAT NEEDED + HOW DELIVERED). Gives external CLIs the operating constraints inline so they don't rediscover sandbox/scope/format gotchas. ~600 tokens; cost is acceptable for consensus calls.
- **Graceful degradation table** — explicit fallback paths for: Gemini 429 (retry with flash, then Sonnet), Codex CLI missing (Sonnet substitute), both external CLIs down (3-Claude mode), single validator timeout (raised confidence threshold for remaining two). Orchestrator must surface degradation in report so user can audit affected decisions.

### Why

Validator review of pos-harness consensus invocation surfaced real production failures: Gemini rate-limited mid-overnight on preview-tier capacity, Codex producing shallow stress-tests at default reasoning effort. Both shipping defaults were wrong for high-leverage consensus calls.

Felipe directive 2026-04-28: *"We should use the best models for consensus. We need thinking, not speed."*

## [2.1.0] - 2026-03-31

### Added

- **HTML report generation**: `scripts/generate-report.sh` produces a self-contained HTML report from `consensus-state.json`. Dark/light mode, print-to-PDF, expandable validator details with claims and justifications.
- **Phase 4 (Save State + Report)**: Consensus command now writes structured JSON state file and auto-generates HTML report after every validation.

## [2.0.0] - 2026-03-31

### Added

- **`--type` validation modes**: 7 types (general, architecture, plan, timeline, idea, design, security). Each type has its own rubric dimensions, key question, and validator-specific focus overrides.
- **`config/type-profiles.json`**: Structured type definitions with per-validator focus instructions.
- **`config/consensus-schema.json`**: Formal JSON Schema (draft-2020-12) for consensus output. Validators and report structure validated against schema.
- **New eval fixtures**: architecture-conclusion.md (ECS migration), security-conclusion.md (JWT cookies).
- **Expanded validation-patterns.md**: Added plan, timeline, idea, and security validation guidance.
- **20 new structural eval checks** for type profiles, schema, and fixtures (80 total).

### Changed

- `--domain` renamed to `--type` (backward compatible — both accepted).
- Signature line now shows validation type: `SpSk consensus v2.0.0 ── Architecture · opus+codex+gemini`
- Evidence package includes rubric dimensions and key question from the selected type.

## [1.0.0] - 2026-03-30

### Added

- `/consensus` command — validate any conclusion with 3 independent AI models
- Deep Verifier (Opus): claim verification against evidence
- Devil's Advocate (Codex): counter-argument and bias detection
- Scope Analyst (Gemini): second-order effects and missing perspectives
- Confidence scoring on 1-10 scale with 4-tier verdict system
- Domain-specific validation patterns (architecture, code, design, strategy, incident)
- `--evidence` flag for including supporting evidence files
- `--domain` flag for focused validation
- `--quick` flag for 2-validator mode
- 3-tier degradation: full (3 external models) → partial (2) → fallback (3 Claude personas)
- SpSk branded output with score bars and section boxes
- Structural eval harness with 42 assertions
- PostToolUse hook suggesting consensus after decision-related edits

### The Journey

This started as an incident-only root cause validator. It worked, but was too narrow — you'd only use it when debugging production issues. The rewrite generalizes it to validate ANY conclusion: architecture calls, design direction, feature priority, strategy decisions. The 3-model approach isn't about having more opinions — it's about having genuinely different reasoning patterns. Claude, Codex, and Gemini have different training data and different blind spots. That diversity is the value.
