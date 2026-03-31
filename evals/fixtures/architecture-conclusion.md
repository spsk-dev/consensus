## Conclusion
"We should migrate from a monolithic NestJS backend to microservices using AWS ECS with event-driven communication via SQS."

## Evidence
1. The monolith handles 12 services in one codebase (47K LOC) — deploys take 18 minutes and a failure in billing blocks auth deployments.
2. The team has grown from 3 to 9 engineers in 6 months — merge conflicts on shared modules average 4 per week.
3. AWS ECS is already used for 2 background workers (PDF generation, email sending) — the team has operational experience.
4. SQS is used for the existing workers — adding more queues follows an established pattern.
5. Three services (billing, auth, notifications) have been identified as natural boundaries with minimal shared state.
6. The migration plan proposes a strangler fig pattern over 3 months, extracting one service per month.

## Domain
architecture

## What Was Considered
- Modular monolith with better module boundaries (lower risk but doesn't solve deploy coupling)
- Kubernetes instead of ECS (more flexible but team has no K8s experience)
- Event sourcing with Kafka (more powerful but significantly more complex than SQS)
