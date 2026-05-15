# Lab: User role controlled by request parameter (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Lab Description

This lab exposes an admin panel at `/admin` and uses a client-controlled value to decide whether the current user should
be treated as an administrator.

Goal: tamper with the role indicator, access the admin panel, and delete the user `carlos`.

## Overview (why this works)

Authorization decisions must be derived on the server from the authenticated user identity. In this lab, the application
stores an admin indicator in a user-controlled location and later trusts that value when serving privileged functionality.
Because the browser can modify cookies and request parameters, an attacker can simply forge the admin state.

## Summary

The application exposes an admin panel at `/admin` and identifies administrators using a forgeable client-side value
(`Admin`). By tampering with this value, a normal user can access admin functionality and perform privileged actions.

## Steps to Reproduce (high-level)

1. Log in as the provided low-privilege user `wiener:peter`.
2. Browse to `/admin` and confirm the panel is not accessible with the default session.
3. Intercept the login flow or inspect the response cookies and identify the admin indicator, for example `Admin=false`.
4. Change the client-controlled value to `Admin=true`.
5. Revisit `/admin` with the modified cookie.
6. Confirm the admin panel is now accessible and use it to delete `carlos`.

## Evidence

### Baseline (non-admin)

```http
GET /admin HTTP/2
Host: <lab-host>
Cookie: Admin=false; session=<session>
```

Expected result: access denied or redirect because the session is still treated as non-admin.

### Privilege escalation (admin flag tampering)

Login flow sets a forgeable admin indicator:

```http
Set-Cookie: Admin=false; session=<session>
```

After tampering the flag:

```http
GET /admin HTTP/2
Host: <lab-host>
Cookie: Admin=true; session=<session>
```

Observed result: the admin panel becomes accessible and privileged actions such as deleting `carlos` are allowed.

## Impact

Privilege escalation to administrator. In a real application this can lead to account takeover, destructive actions,
configuration changes, and broad data exposure.

## Severity

- Rating: High
- Rationale: Direct privilege escalation via client-controlled authorization state.

## Recommendation

- Never trust client-side role indicators such as cookies, hidden fields, or query parameters.
- Enforce authorization server-side based on the authenticated user identity and stored permissions.
- Apply authorization checks to every sensitive endpoint, not just UI links.
- Add authorization-focused unit/integration tests for admin-only routes and actions.

## Retest Plan

- Confirm changing any client-controlled admin value no longer affects authorization.
- Verify non-admin users always receive a blocked response on `/admin` and related admin actions.

## Executive Summary

An attacker can escalate privileges by modifying a client-controlled admin flag. This grants access to the admin panel
and allows privileged actions such as deleting other users. The issue exists because the application trusts a value
supplied by the browser instead of deriving authorization from the authenticated user on the server. The fix is to enforce
role/permission checks server-side on every sensitive endpoint and remove any client-trusted admin state.
