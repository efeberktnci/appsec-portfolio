# Lab: User role controlled by request parameter (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Summary
The application exposes an admin panel at `/admin` and identifies administrators using a forgeable client-side value (`Admin`).
By tampering with this value, a normal user can access admin functionality and perform privileged actions.

## Steps to Reproduce (high-level)
1. Log in as the provided low-priv user (e.g., `wiener:peter`).
2. Attempt to visit `/admin` and confirm access is denied.
3. Intercept the login flow with Burp and find where the application sets an admin indicator (e.g., `Admin=false`).
4. Modify the value to indicate admin privileges (e.g., change to `Admin=true`).
5. Visit `/admin` again and confirm admin panel access.
6. Perform a privileged action (in the lab: delete user `carlos`).

## Evidence (sanitized)
### Baseline (non-admin)
Request (sanitized):
```http
GET /admin HTTP/2
Host: <lab-host>
Cookie: Admin=false; session=<redacted>
```

Expected result: access denied (e.g., 401/403 or redirect).

### Privilege escalation (admin flag tampering)
**TODO (add from Burp, sanitized):**
1) Login response sets a forgeable admin indicator:
```http
Set-Cookie: Admin=false; session=<redacted>
```
2) After tampering the flag:
```http
GET /admin HTTP/2
Host: <lab-host>
Cookie: Admin=true; session=<redacted>
```
Observed result: admin panel accessible (e.g., 200 OK) and privileged action possible (lab: delete `carlos`).

## Impact
Privilege escalation to administrator. In real systems this can lead to account takeover, data exposure, and destructive actions.

## Severity
- Rating: High
- Rationale: Direct privilege escalation via client-controlled authorization state.

## Recommendation
- Never trust client-side role indicators (cookies, hidden fields, query params) for authorization.
- Enforce authorization server-side based on authenticated user identity (session → user → role/permissions).
- Add authorization checks on every sensitive endpoint (`/admin/*`), not just UI links.
- Add tests: authorization unit/integration tests for admin endpoints.

## Retest Plan
After fix, verify that:
- Tampering with any client-side `Admin` indicator does not change authorization outcome.
- Access to `/admin` is blocked for non-admin users (403) across endpoints and actions.

## Executive Summary (5–10 lines)
An attacker can escalate privileges by modifying a client-controlled admin flag. This allows access to the admin panel and
execution of privileged actions. The issue exists because the application trusts a value provided by the client rather than
enforcing authorization on the server. Fix by deriving permissions server-side from the authenticated user and applying
authorization checks to every admin endpoint. Add automated tests to prevent regressions.
