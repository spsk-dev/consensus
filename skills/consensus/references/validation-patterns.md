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

## Plan Validation

**Deep Verifier focus:** Check each prerequisite and dependency against current reality. Do the files, APIs, and systems referenced actually exist? Are version requirements met? Is the proposed order of operations correct?

**Devil's Advocate focus:** Find the step that will fail. What prerequisite is missing? What dependency will block progress? What's underestimated by 3x?

**Scope Analyst focus:** What happens after the plan executes? What maintenance burden does it create? What was left out of scope that will come back to haunt the team?

## Timeline Validation

**Deep Verifier focus:** Check dependency chains. Are parallel tasks truly independent? Verify resource availability claims. Compare estimates against historical data for similar work.

**Devil's Advocate focus:** Find the bottleneck. Which task is underestimated? What hidden dependency makes the critical path longer than shown? Where is the optimism bias?

**Scope Analyst focus:** What external factors could shift the timeline? Holidays, other team priorities, vendor dependencies, approval processes? What happens if the hardest task takes 2x?

## Idea Validation

**Deep Verifier focus:** Verify the problem exists. Check if the proposed solution actually addresses the stated problem. Look for evidence of user need — not just team enthusiasm.

**Devil's Advocate focus:** Propose the strongest alternative. Why would doing nothing be better? What simpler approach was dismissed too quickly? What's the opportunity cost?

**Scope Analyst focus:** What downstream commitments does this imply? What else won't get done? How does this change the team's trajectory for the next 6 months?

## Security Validation

**Deep Verifier focus:** Trace the data flow. Where does sensitive data enter, move, and persist? Verify encryption, access controls, and token handling. Check trust boundaries.

**Devil's Advocate focus:** Think like an attacker. What is the easiest way to compromise this? What happens if a dependency is compromised? What if credentials leak?

**Scope Analyst focus:** What compliance implications exist? What audit trail is needed? What happens when credentials rotate or expire? What's the incident response plan?
