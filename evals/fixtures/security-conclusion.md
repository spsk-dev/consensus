## Conclusion
"Storing JWT access tokens in httpOnly cookies with a 15-minute expiry and refresh tokens in a separate httpOnly cookie with 7-day expiry is secure for our B2B SaaS application."

## Evidence
1. httpOnly cookies prevent XSS from stealing tokens — JavaScript cannot read httpOnly cookies.
2. 15-minute access token expiry limits the window if a token is somehow compromised.
3. Refresh tokens with 7-day expiry reduce re-authentication friction for daily users.
4. SameSite=Strict on both cookies prevents CSRF attacks from third-party sites.
5. The application runs on a single domain (app.example.com) — no cross-origin cookie concerns.
6. Refresh token rotation is implemented — each refresh invalidates the previous token.

## Domain
security

## What Was Considered
- localStorage for tokens (rejected: vulnerable to XSS)
- Session-based auth with server-side storage (rejected: doesn't scale horizontally without sticky sessions or shared session store)
- OAuth 2.0 with third-party IdP (considered for future but adds dependency for MVP)
