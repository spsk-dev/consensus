# Test Fixture: Gray Area Conclusion

**Expected verdict:** MODERATE CONFIDENCE (6-7/10)

## Conclusion
"GraphQL is the right choice over REST for our new mobile API."

## Evidence
1. Mobile app needs data from 4 different backend services per screen
2. Current REST approach requires 4 sequential API calls (waterfall pattern)
3. GraphQL would reduce this to 1 request with a unified schema
4. Mobile clients are bandwidth-constrained — GraphQL enables field-level selection
5. Team has 2 engineers with GraphQL experience (out of 8)
6. Existing REST API serves web clients successfully and will need to be maintained in parallel

## Context
Fintech company. New mobile app launching in Q3. Existing REST API serves web dashboard. Backend is Node.js + PostgreSQL. No caching layer. Team has strong REST experience but limited GraphQL exposure.
