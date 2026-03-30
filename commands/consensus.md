---
description: Validate any conclusion with 3 independent AI models. Confidence-scored 1-10.
---

# /consensus — Multi-Model Consensus Validation

@${CLAUDE_PLUGIN_ROOT}/shared/output.md
@${CLAUDE_PLUGIN_ROOT}/config/output-schema.json

## What This Does

Validates **any conclusion, decision, or analysis** by dispatching it to 3 independent AI models (Claude Opus, OpenAI Codex, Google Gemini). Each model evaluates the conclusion from a different analytical lens. Results are synthesized into a consensus report with confidence scores on a 1-10 scale.

**Not limited to code or incidents.** Use it for architecture decisions, design direction, feature prioritization, root cause analysis, hiring decisions, strategy calls — anything where you've formed a conclusion and want independent validation before acting on it.

## Usage

```
/consensus "Our API should use GraphQL instead of REST for the new mobile app"
/consensus "The performance regression is caused by the N+1 query in the user loader"
/consensus "We should prioritize the billing rewrite over the notification system"
/consensus --evidence @analysis.md "The auth middleware is the root cause"
/consensus --domain architecture "Microservices is the right call for this team size"
```

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `"conclusion"` | Yes | The conclusion, decision, or analysis to validate (quoted string) |
| `--evidence <file>` | No | File containing supporting evidence (read and included in evidence package) |
| `--domain <type>` | No | Hint for validator focus: `architecture`, `code`, `design`, `strategy`, `incident`, `general` |
| `--quick` | No | Run 2 validators instead of 3 (skip Gemini if unavailable) |

## Execution Protocol

### Phase 0: Parse Input

Extract the conclusion from arguments. If `--evidence` is provided, read the file. If no evidence file, scan the conversation context for relevant data, code references, or prior analysis that supports the conclusion.

Build the **evidence package**:

```markdown
## Evidence Package

### Conclusion Under Review
{The conclusion, decision, or analysis being validated}

### Domain
{Detected or specified: architecture | code | design | strategy | incident | general}

### Supporting Evidence
{Evidence items — from file, conversation, or codebase analysis}
1. {Evidence item with source reference}
2. {Evidence item with source reference}
...

### Context
{Relevant background — what prompted this conclusion, what alternatives exist}

### What Was Considered
{Alternatives that were evaluated and why they were dismissed}
```

### Phase 1: Pre-flight — Verify External CLIs

```bash
which codex && which gemini
```

- **Both installed**: Proceed with 3 validators (Claude Opus + Codex + Gemini)
- **Only one installed**: Proceed with 2 validators (Opus + whichever is available). Use a Sonnet agent as fallback for the missing CLI.
- **Neither installed**: Fall back to 3 Claude agents (Opus + 2x Sonnet with distinct analytical personas). Note in the report that external models were unavailable.
- **`--quick` flag**: Use 2 validators only (Opus + best available external model)

### Phase 2: Dispatch Three Validators in Parallel

Launch all validators in a SINGLE message with parallel tool calls. Each gets the same evidence package but a different analytical lens.

**CRITICAL: Do not coach validators toward the conclusion.** Present evidence neutrally. The whole point is independent analysis.

#### Validator 1: "Deep Verifier" (Claude Opus Agent)

**Role:** Methodical claim verifier. Traces every claim back to evidence. Reads actual source files if code is involved. Doesn't trust summaries.

**Prompt:**
```
You are an independent deep verifier for a conclusion validation.
Your role: methodically verify every claim by checking actual evidence. Don't trust summaries — verify firsthand.

## Evidence Package
{evidence_package}

## Your Tasks
1. **Verify each claim**: Does the evidence actually support what's claimed? Trace the reasoning chain.
2. **Check for alternative explanations**: Could something ELSE explain the same evidence? What assumptions is the conclusion making?
3. **Validate the evidence itself**: Is each piece of evidence actually proving what it's claimed to prove? Are there gaps?
4. **Rate confidence**: 1-10, with specific justification for each point deducted.

## Output Format

You MUST return your analysis in this exact structure. First reason freely, then provide structured output.

<thinking>
{Your detailed analysis — trace claims, check evidence, consider alternatives. Be thorough.}
</thinking>

<validator_output>
{
  "validator": "deep_verifier",
  "model": "opus",
  "confidence": {1-10},
  "confidence_justification": "{specific deductions from 10}",
  "key_finding": "{one sentence, max 100 chars}",
  "claims": [
    {"claim": "{claim text}", "status": "CONFIRMED|UNCONFIRMED|PARTIALLY_CONFIRMED", "evidence": "{supporting or contradicting evidence}"}
  ],
  "counter_arguments": [
    {"argument": "{counter}", "strength": "strong|moderate|weak", "evidence": "{basis}"}
  ],
  "gaps": ["{missing evidence or analysis}"]
}
</validator_output>
```

#### Validator 2: "Devil's Advocate" (OpenAI Codex CLI)

**Role:** Adversarial reviewer. Actively tries to find the strongest counter-argument. Not malicious — genuinely stress-testing.

Write the evidence package to a temp file, then pipe to Codex:

```bash
cat /tmp/consensus-evidence.md | codex exec --full-auto "You are an independent devil's advocate reviewer. Your job is to find the STRONGEST counter-argument to the proposed conclusion. The evidence has been piped via stdin.

Your tasks:
1. Attack the conclusion: What's the weakest link? What assumption, if wrong, collapses the entire argument?
2. Check for confirmation bias: Is evidence being interpreted to fit the conclusion? What contrary evidence exists?
3. Completeness check: Does the conclusion account for ALL relevant factors or just convenient ones?
4. Propose the strongest counter-conclusion: What's the best alternative?
5. Rate confidence in the ORIGINAL conclusion: 1-10 with specific deductions.

You MUST return your analysis in this structure. First reason freely, then provide structured output.

<thinking>
{Your adversarial analysis}
</thinking>

<validator_output>
{
  \"validator\": \"devils_advocate\",
  \"model\": \"codex\",
  \"confidence\": {1-10},
  \"confidence_justification\": \"{specific deductions from 10}\",
  \"key_finding\": \"{one sentence, max 100 chars}\",
  \"claims\": [{\"claim\": \"{claim}\", \"status\": \"CONFIRMED|UNCONFIRMED|PARTIALLY_CONFIRMED\", \"evidence\": \"{evidence}\"}],
  \"counter_arguments\": [{\"argument\": \"{counter}\", \"strength\": \"strong|moderate|weak\", \"evidence\": \"{basis}\"}],
  \"gaps\": [\"{missing evidence}\"]
}
</validator_output>"
```

#### Validator 3: "Scope Analyst" (Google Gemini CLI)

**Role:** Second-order effects analyst. Checks what was missed, downstream consequences, and whether the conclusion addresses the right level of the problem.

```bash
cat <<'GEMINI_PROMPT_EOF' > /tmp/consensus-gemini-prompt.md
You are an independent scope and impact analyst validating a conclusion.

## Evidence Package
$(cat /tmp/consensus-evidence.md)

## Your Tasks
1. Scope check: Is this conclusion addressing the right problem at the right level? Could the real issue be higher or lower in the stack?
2. Second-order effects: What happens AFTER acting on this conclusion? What downstream consequences weren't considered?
3. Reversibility: How easy is it to course-correct if this conclusion is wrong? What's the cost of being wrong?
4. Missing perspectives: Whose viewpoint is absent from this analysis? What domain expertise wasn't consulted?
5. Rate confidence: 1-10 with specific deductions.

You MUST return your analysis in this structure. First reason freely, then provide structured output.

<thinking>
{Your scope and impact analysis}
</thinking>

<validator_output>
{
  "validator": "scope_analyst",
  "model": "gemini",
  "confidence": {1-10},
  "confidence_justification": "{specific deductions from 10}",
  "key_finding": "{one sentence, max 100 chars}",
  "claims": [{"claim": "{claim}", "status": "CONFIRMED|UNCONFIRMED|PARTIALLY_CONFIRMED", "evidence": "{evidence}"}],
  "counter_arguments": [{"argument": "{counter}", "strength": "strong|moderate|weak", "evidence": "{basis}"}],
  "gaps": ["{missing evidence}"]
}
</validator_output>
GEMINI_PROMPT_EOF

cd {repo-root} && gemini -y -p "$(cat /tmp/consensus-gemini-prompt.md)"
```

**Fallback personas** (when external CLIs unavailable):

- **Codex fallback (Sonnet agent):** "You are an adversarial reviewer trained to find counter-arguments. You have a different reasoning style than the primary analyst — you prioritize finding holes over building support."
- **Gemini fallback (Sonnet agent):** "You are a scope and impact analyst. You think in systems — second-order effects, reversibility, stakeholder perspectives that weren't consulted."

### Phase 3: Synthesize Consensus

After all validators return, the orchestrator (YOU) synthesizes the consensus report.

**Read the version from `${CLAUDE_PLUGIN_ROOT}/VERSION`.**

Display the branded signature line:

```
 SpSk  consensus  v{version}  ───  3 models  ·  {model_config}
```

Where `{model_config}` is: `opus+codex+gemini` | `opus+codex+sonnet` | `opus+sonnet+sonnet` | etc.

Then display the consensus report:

```
┌─────────────────────────────────────────────────────────────┐
│  CONSENSUS REPORT                                           │
└─────────────────────────────────────────────────────────────┘

 Conclusion: {the conclusion being validated}

┌─────────────────────────────────────────────────────────────┐
│  VALIDATOR VERDICTS                                         │
└─────────────────────────────────────────────────────────────┘

 Deep Verifier    (Opus)    {confidence}/10  {1-line key finding}
 Devil's Advocate (Codex)   {confidence}/10  {1-line key finding}
 Scope Analyst    (Gemini)  {confidence}/10  {1-line key finding}

 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Consensus Confidence:  {avg}/10  {verdict}
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Verdict logic** (from `${CLAUDE_PLUGIN_ROOT}/config/scoring.json`):

| Consensus Score | Verdict | Meaning |
|-----------------|---------|---------|
| 8.0 - 10.0 | HIGH CONFIDENCE | Strong agreement — proceed with confidence |
| 6.0 - 7.9 | MODERATE CONFIDENCE | Likely correct with caveats — note gaps |
| 4.0 - 5.9 | LOW CONFIDENCE | Significant disagreement — investigate further |
| 1.0 - 3.9 | NO CONSENSUS | Validators disagree or found critical flaws — do not proceed |

Then display the detailed findings:

```
┌─────────────────────────────────────────────────────────────┐
│  CONFIRMED BY ALL                                           │
└─────────────────────────────────────────────────────────────┘

 - {claims all three validators agree on}

┌─────────────────────────────────────────────────────────────┐
│  DISPUTED OR UNCONFIRMED                                    │
└─────────────────────────────────────────────────────────────┘

 - {claims where validators disagree, with both sides}

┌─────────────────────────────────────────────────────────────┐
│  NEW FINDINGS                                               │
└─────────────────────────────────────────────────────────────┘

 - {anything discovered by validators not in the original analysis}

┌─────────────────────────────────────────────────────────────┐
│  GAPS REQUIRING INVESTIGATION                               │
└─────────────────────────────────────────────────────────────┘

 - {evidence that would resolve disputes or increase confidence}
```

Finally, the recommendation:

```
┌─────────────────────────────────────────────────────────────┐
│  RECOMMENDATION                                             │
└─────────────────────────────────────────────────────────────┘

 {Based on consensus score and findings:}

 {If HIGH: "Proceed. The conclusion is well-supported across all three models."}
 {If MODERATE: "Proceed with awareness of [specific gaps]. Consider [specific investigation] to increase confidence."}
 {If LOW: "Pause. Competing theories: [list]. Investigate [specific evidence] to distinguish them."}
 {If NO CONSENSUS: "Do not proceed. The validators found [critical flaw / fundamental disagreement]. Revisit the analysis."}
```

End with the branded footer from `@${CLAUDE_PLUGIN_ROOT}/shared/output.md`.

## Rules

1. **Always dispatch all validators in parallel** — in a SINGLE message with parallel tool calls. Never sequentially.
2. **Give validators access to the codebase** — they need to read files, check context, verify claims independently.
3. **Do not coach validators** — present evidence neutrally. The point is independent analysis.
4. **Respect the confidence thresholds** — don't present a 4/10 as "confirmed" because you personally believe it.
5. **Include the evidence package in the report** — the user should trace every claim back to evidence.
6. **If a validator finds something that changes the picture**, call it out prominently. Don't bury inconvenient findings.
7. **Clean up temp files** after execution: `rm -f /tmp/consensus-evidence.md /tmp/consensus-gemini-prompt.md`
