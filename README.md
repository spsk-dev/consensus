# SpSk Consensus

**3-model consensus validation for any conclusion.** Dispatches your analysis to Claude Opus, OpenAI Codex, and Google Gemini in parallel. Each model evaluates from a different analytical lens. Results synthesized with confidence scores on a 1-10 scale.

Not limited to code. Use it for architecture decisions, design direction, root cause analysis, feature prioritization, strategy calls — anything where you've formed a conclusion and want independent validation.

## Install

```bash
claude /install-plugin consensus@spsk-dev/consensus
```

Or manually:
```bash
curl -fsSL https://raw.githubusercontent.com/spsk-dev/consensus/main/install.sh | bash
```

## Usage

```bash
# Validate any conclusion
/consensus "GraphQL is better than REST for our mobile API"

# Include supporting evidence
/consensus --evidence @analysis.md "The auth middleware is the root cause"

# Focus on a specific domain
/consensus --domain architecture "Microservices is the right call for this team size"

# Quick mode (2 validators)
/consensus --quick "We should prioritize billing over notifications"
```

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

SpSk publishes polished AI agent skills as open-source Claude Code plugins.

| Plugin | What it does | Install |
|--------|-------------|---------|
| [tasteful-design](https://github.com/spsk-dev/tasteful-design) | 7-specialist design review + SPA flow audit | `claude /install-plugin tasteful-design@spsk-dev/tasteful-design` |
| [code-review](https://github.com/spsk-dev/code-review) | 7-agent multi-model PR review | `claude /install-plugin code-review@spsk-dev/code-review` |
| **consensus** | 3-model conclusion validation | `claude /install-plugin consensus@spsk-dev/consensus` |

## License

MIT
