# Changelog

All notable changes to the SpSk consensus plugin.

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
