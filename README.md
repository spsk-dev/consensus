# SpSk Consensus

**3-model consensus validation for any conclusion.** Dispatches your analysis to Claude Opus, OpenAI Codex, and Google Gemini in parallel. Each model evaluates from a different analytical lens. Results synthesized with confidence scores on a 1-10 scale.

Not limited to code. Use it for architecture decisions, design direction, root cause analysis, feature prioritization, strategy calls — anything where you've formed a conclusion and want independent validation.

## Install

### 1. Install the plugin

```bash
# Add SpSk marketplace (one time)
claude plugins marketplace add spsk-dev/marketplace

# Install consensus
claude plugins install consensus@spsk
```

### 2. Set up external models (recommended for full 3-model validation)

```bash
# Codex CLI (Devil's Advocate validator)
npm install -g @openai/codex

# Gemini CLI (Scope Analyst validator)
npm install -g @anthropic/gemini-cli
```

Without external CLIs, consensus falls back to 3 Claude agents with distinct personas. Works, but you lose the cross-model diversity that makes consensus valuable.

### Verify installation

```bash
claude /help
# Look for: /consensus
```

### Manual install (alternative)

```bash
git clone https://github.com/spsk-dev/consensus.git
cd consensus && bash install.sh
```

## Usage

```bash
# Validate any conclusion
/consensus "GraphQL is better than REST for our mobile API"

# Type-aware validation — changes rubric and validator focus
/consensus --type architecture "Microservices is the right call"
/consensus --type plan "Migration plan in migration.md"
/consensus --type timeline "Ship auth rewrite by March 15"
/consensus --type security "JWT in httpOnly cookies is secure"
/consensus --type idea "Build a CLI instead of a web app"
/consensus --type design "Dark mode with warm palette"

# Include supporting evidence
/consensus --evidence @analysis.md "The auth middleware is the root cause"

# Quick mode (2 validators)
/consensus --quick "We should prioritize billing over notifications"
```

### Validation Types

| Type | Key Question | Rubric Focus |
|------|-------------|--------------|
| `general` | Is this conclusion correct? | Evidence quality, logic, alternatives, completeness |
| `architecture` | Will this architecture work? | Feasibility, dependencies, migration, scalability |
| `plan` | Will this plan succeed? | Prerequisites, sequencing, scope, rollback, evaluation |
| `timeline` | Is this timeline realistic? | Dependencies, parallelism, buffer, resources |
| `idea` | Is this worth pursuing? | Problem fit, effort/impact, alternatives, reversibility |
| `design` | Is this the right direction? | Intent match, consistency, accessibility, originality |
| `security` | Is this approach secure? | Threat surface, auth, data flow, trust boundaries |

## How It Works

```
Your conclusion
     │
     ├──► Deep Verifier (Opus)     ── Traces claims back to evidence
     ├──► Devil's Advocate (Codex) ── Finds the strongest counter-argument
     └──► Scope Analyst (Gemini)   ── Checks second-order effects & missing perspectives
     │
     ▼
Consensus Report (1-10 confidence)
```

**Three validators, three lenses:**

| Validator | Model | Focus |
|-----------|-------|-------|
| Deep Verifier | Claude Opus | Verify every claim against evidence. Read actual files. Don't trust summaries. |
| Devil's Advocate | OpenAI Codex | Find the strongest counter-argument. Check for confirmation bias. |
| Scope Analyst | Google Gemini | Second-order effects. Missing perspectives. Reversibility. |

## Output

```
 SpSk  consensus  v1.0.0  ───  3 models  ·  opus+codex+gemini

┌─────────────────────────────────────────────────────────────┐
│  VALIDATOR VERDICTS                                         │
└─────────────────────────────────────────────────────────────┘

 Deep Verifier    (Opus)    8/10  Claims verified against codebase
 Devil's Advocate (Codex)   6/10  Found one unaddressed alternative
 Scope Analyst    (Gemini)  7/10  Migration cost not fully considered

 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Consensus Confidence:  7.0/10  MODERATE CONFIDENCE
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Confidence Scale

| Score | Verdict | Meaning |
|-------|---------|---------|
| 8-10 | HIGH CONFIDENCE | Strong agreement — proceed |
| 6-7.9 | MODERATE CONFIDENCE | Likely correct with caveats |
| 4-5.9 | LOW CONFIDENCE | Significant disagreement — investigate |
| 1-3.9 | NO CONSENSUS | Critical flaws found — do not proceed |

## Degradation

The plugin adapts to available tools:

- **Full** (Opus + Codex + Gemini): Maximum reasoning diversity
- **Partial** (Opus + 1 external): One external perspective
- **Fallback** (Opus + 2x Sonnet): Different personas, same model family

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- Optional: [Codex CLI](https://github.com/openai/codex) (`codex`)
- Optional: [Gemini CLI](https://github.com/google/gemini-cli) (`gemini`)

## Part of SpSk

Polished AI agent skills for Claude Code. See more at [github.com/spsk-dev](https://github.com/spsk-dev).

## License

MIT
