# Architecture: SpSk Consensus

## System Overview

```
                    ┌──────────────────────┐
                    │   /consensus "..."    │
                    │   User's conclusion   │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │   Phase 0: Parse     │
                    │   Build evidence     │
                    │   package            │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │   Phase 1: Pre-flight│
                    │   Detect CLIs        │
                    │   (codex, gemini)    │
                    └──────────┬───────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
    ┌─────────▼──────┐ ┌──────▼───────┐ ┌──────▼───────┐
    │ Deep Verifier  │ │ Devil's      │ │ Scope        │
    │ (Opus agent)   │ │ Advocate     │ │ Analyst      │
    │                │ │ (Codex CLI)  │ │ (Gemini CLI) │
    │ Traces claims  │ │ Counter-args │ │ 2nd-order    │
    │ back to        │ │ Bias check   │ │ effects      │
    │ evidence       │ │ Alternatives │ │ Perspectives │
    └─────────┬──────┘ └──────┬───────┘ └──────┬───────┘
              │                │                │
              │   <validator_output> JSON each  │
              └────────────────┼────────────────┘
                               │
                    ┌──────────▼───────────┐
                    │   Phase 3: Synthesize│
                    │   Average confidence │
                    │   Merge findings     │
                    │   Consensus verdict  │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │   Branded Report     │
                    │   1-10 confidence    │
                    │   Verdict + action   │
                    └──────────────────────┘
```

## Three Validators, Three Lenses

The value of 3-model consensus is not "more opinions" — it's genuinely different reasoning patterns. Each model has different training data and different blind spots. A conclusion that survives all three is more likely correct.

| Validator | Model | Analytical Lens | Why This Model |
|-----------|-------|-----------------|----------------|
| Deep Verifier | Claude Opus | Claim-by-claim evidence verification | Best at methodical reasoning, can read files |
| Devil's Advocate | OpenAI Codex | Adversarial counter-arguments, bias detection | Different training data = different blind spots |
| Scope Analyst | Google Gemini | Second-order effects, missing perspectives | Third reasoning architecture, strong at broad pattern recognition |

## Degradation Tiers

| Tier | Config | Quality |
|------|--------|---------|
| Full | Opus + Codex + Gemini | Maximum reasoning diversity |
| Partial | Opus + 1 external | One independent perspective |
| Fallback | Opus + 2x Sonnet | Different personas, same model family |

The plugin detects available CLIs at runtime (`which codex && which gemini`) and adapts. Sonnet fallback agents use distinct analytical personas to maximize diversity within the same model family.

## Structured Output Contract

Every validator returns structured JSON in `<validator_output>` tags:

```json
{
  "validator": "deep_verifier",
  "model": "opus",
  "confidence": 7,
  "confidence_justification": "specific deductions from 10",
  "key_finding": "one sentence, max 100 chars",
  "claims": [
    {"claim": "...", "status": "CONFIRMED|UNCONFIRMED|PARTIALLY_CONFIRMED", "evidence": "..."}
  ],
  "counter_arguments": [
    {"argument": "...", "strength": "strong|moderate|weak", "evidence": "..."}
  ],
  "gaps": ["missing evidence or analysis"]
}
```

The orchestrator synthesizes all three into a consensus report with averaged confidence, merged findings, and a verdict.

## Scoring

| Consensus Score | Verdict | Action |
|-----------------|---------|--------|
| 8.0 - 10.0 | HIGH CONFIDENCE | Proceed |
| 6.0 - 7.9 | MODERATE CONFIDENCE | Proceed with caveats |
| 4.0 - 5.9 | LOW CONFIDENCE | Investigate further |
| 1.0 - 3.9 | NO CONSENSUS | Do not proceed |

**Disagreement flag:** When any two validators differ by >3 points, the report highlights the disagreement and explains both sides. A high average with high disagreement is less trustworthy than a moderate average with agreement.

## Domain-Specific Patterns

The `--domain` flag loads domain-specific guidance from `skills/consensus/references/validation-patterns.md`. Each domain shifts what the validators focus on:

- **architecture:** Technical feasibility, team fit, migration cost
- **code:** Execution paths, race conditions, edge cases
- **design:** User needs vs designer preference, accessibility
- **strategy:** Opportunity cost, stakeholder impact, data quality
- **incident:** Root cause completeness, symptom coverage, recurrence prevention

## File Map

```
consensus/
├── .claude-plugin/plugin.json      Plugin manifest
├── commands/consensus.md           Main command (Phase 0-3 protocol)
├── config/
│   ├── scoring.json                Verdict thresholds and validator config
│   └── output-schema.json          Structured output contract
├── shared/output.md                Branded output reference
├── skills/consensus/
│   ├── SKILL.md                    Skill descriptor
│   └── references/
│       └── validation-patterns.md  Domain-specific validator guidance
├── evals/
│   ├── validate-structure.sh       Structural assertions
│   └── fixtures/                   Test conclusions for eval
├── hooks/hooks.json                PostToolUse suggestion hook
├── scripts/suggest-consensus.sh    Decision-detection trigger
├── ARCHITECTURE.md                 This file
├── CHANGELOG.md                    Release history
├── CLAUDE.md                       Project instructions
├── README.md                       Install + usage
├── VERSION                         Semver version
├── LICENSE                         MIT
└── install.sh                      Manual installer
```

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| 3 models, not 5 | Diminishing returns — 3 models with different architectures cover major reasoning blind spots. Adding more adds latency without proportional diversity. |
| Parallel dispatch | Validators don't influence each other. Independence is the entire point. |
| Structured JSON output | Enables programmatic consumption — CI integration, trend analysis, automated gates. |
| Think-then-structure | Free-form reasoning before JSON preserves analytical quality. Pure JSON constrains thinking. |
| Domain-specific patterns | Different conclusion types need different validation lenses. Architecture decisions need different scrutiny than incident root causes. |
| 1-10 scale, not binary | Binary (agree/disagree) loses nuance. A 6/10 with specific gaps is more useful than "disagree." |
| Disagreement flag at 3pt | Below 3pt spread, validators are roughly aligned. Above 3pt, the disagreement itself is a finding. |
