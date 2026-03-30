# Validation Patterns Reference

Domain-specific guidance for validators based on conclusion type.

## Architecture Decisions

**Deep Verifier focus:** Check that the claimed benefits are real for THIS team/codebase. Verify scale assumptions. Check if the technology has been validated at the claimed scale.

**Devil's Advocate focus:** What's the strongest case for the alternative architecture? What happens when the team grows/shrinks? What's the migration cost if this is wrong?

**Scope Analyst focus:** What downstream systems are affected? What's the operational cost? How does this change the hiring profile?

## Code & Technical Analysis

**Deep Verifier focus:** Read the actual code. Trace the execution path. Verify types, return values, edge cases. Don't trust stack traces alone — reproduce the reasoning.

**Devil's Advocate focus:** Could a different code path produce the same symptoms? What about race conditions, caching, or stale state? Is the fix addressing root cause or symptoms?

**Scope Analyst focus:** What else uses this code? What's the blast radius of the proposed change? Are there tests that would catch a regression?

## Design Direction

**Deep Verifier focus:** Check that design claims are supported by evidence (user research, analytics, competitive analysis). Verify that proposed patterns match the stated user needs.

**Devil's Advocate focus:** Is the design optimizing for the designer's preference or the user's need? What user segment is being ignored? What happens at scale?

**Scope Analyst focus:** How does this affect the design system? What's the implementation cost? What's the accessibility impact?

## Strategy & Prioritization

**Deep Verifier focus:** Verify the data behind the priority call. Check that metrics support the claimed impact. Look for cherry-picked data.

**Devil's Advocate focus:** What's the opportunity cost? What gets delayed? Is this a local maximum that prevents a better outcome?

**Scope Analyst focus:** How does this affect team morale, roadmap credibility, or stakeholder trust? What's the second-order effect on other teams?

## Incident & Root Cause

**Deep Verifier focus:** Trace the code path end-to-end. Check logs, timestamps, and state at each step. Verify the theory explains ALL symptoms, not just some.

**Devil's Advocate focus:** What other root causes could produce identical symptoms? Is the team anchored on the first plausible explanation? What evidence contradicts the theory?

**Scope Analyst focus:** How many entities are affected? Has this happened before? Does the proposed fix prevent recurrence or just patch this instance?
