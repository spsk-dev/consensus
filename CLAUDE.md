# SpSk Consensus — Multi-Model Validation Plugin

3-model consensus validation for any conclusion. Dispatches to Claude Opus, OpenAI Codex, and Google Gemini in parallel. Each model evaluates from a different analytical lens. Confidence scored 1-10.

## Command

### `/consensus` — Validate Any Conclusion

```bash
/consensus "Your conclusion here"
/consensus --evidence @analysis.md "The root cause is X"
/consensus --domain architecture "Microservices is the right call"
/consensus --quick "GraphQL over REST for mobile"
```

| Flag | Effect |
|------|--------|
| `--evidence <file>` | Include supporting evidence from a file |
| `--domain <type>` | Focus validators: architecture, code, design, strategy, incident, general |
| `--quick` | Run 2 validators instead of 3 |

**Output:** Confidence scores from 3 independent models, consensus score 1-10, verdict (HIGH/MODERATE/LOW/NO CONSENSUS), confirmed claims, disputed findings, evidence gaps, recommendation.

## Degradation

- **3 models** (Opus + Codex + Gemini): Best diversity — different training data, different reasoning
- **2 models** (Opus + 1 external): Good diversity — one external perspective
- **3 Claude** (Opus + 2x Sonnet): Fallback — different personas but same model family

## Project

**SpSk (Simple Skill)** — A GitHub portfolio of polished AI agent skills as open-source Claude Code plugins.

- `spsk-dev/tasteful-design` — 7-specialist design review + flow audit (v1.2.0)
- `spsk-dev/code-review` — 7-agent multi-model PR review (v1.0.0)
- `spsk-dev/consensus` — 3-model consensus validation (v1.0.0)
