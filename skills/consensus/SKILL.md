---
name: consensus
description: 3-model consensus validation for any conclusion, decision, or analysis
triggers:
  - consensus
  - validate
  - "are we sure"
  - "second opinion"
  - "cross-check"
---

# Consensus Validation

Validates any conclusion by dispatching it to 3 independent AI models. Each model evaluates from a different analytical lens. Results synthesized with confidence scores on a 1-10 scale.

## When to Use

- You've formed a conclusion and want independent validation
- Architecture or design decisions before committing
- Root cause analysis before applying a fix
- Feature prioritization or strategy calls
- Any time you think "I'm pretty sure about this" — that's the trigger

## Install

```bash
claude /install-plugin consensus@spsk-dev/consensus
```

## Quick Start

```bash
/consensus "GraphQL is better than REST for our mobile API"
/consensus --evidence @analysis.md "The auth middleware is the root cause"
/consensus --domain architecture "Microservices is right for this team size"
```
