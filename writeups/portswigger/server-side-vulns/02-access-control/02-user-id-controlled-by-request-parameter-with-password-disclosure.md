# Lab: User ID controlled by request parameter with password disclosure (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Lab Description

This lab uses a user-controlled `id` parameter to decide which account page to render. The account page also exposes the
current password value inside the HTML response.

Goal: access the administrator account page, recover the disclosed password, and use it to gain privileged access.

## Overview (why this works)

This is a broken access control / IDOR-style issue. The application should always map the authenticated session to the
current user's own profile server-side, but instead it trusts a request parameter. Because the target profile also leaks
the password field value, changing `id` to a privileged username immediately becomes an account takeover primitive.

## Summary

The account page uses a user-controlled identifier (`id`) to decide which user's data to load. By setting `id` to a more
privileged user such as `administrator`, the application leaks that user's current password in the HTML response.

## Steps to Reproduce (high-level)

1. Log in as a low-privilege user such as `wiener:peter`.
2. Open the normal account page and observe that the request uses an `id` parameter.
3. Change the request to `GET /my-account?id=administrator`.
4. Inspect the response in Burp and observe that the administrator page loads.
5. Locate the password field value in the returned HTML.
6. Use the disclosed administrator password to log in and perform the privileged action required by the lab.

## Evidence

Request:
- `GET https://<lab-host>/my-account?id=administrator`

Screenshot:

![Burp HTTP history showing /my-account?id=administrator request](assets/password-disclosure-burp-history.webp)

Response pattern:

```http
HTTP/2 200 OK
Content-Type: text/html; charset=utf-8

<p>Your username is: administrator</p>
...
<input required type="hidden" name="csrf" value="<csrf>">
<input required type=password name=password value='<password>'/>
```

## Impact

Credential disclosure enables immediate account takeover. If the disclosed account is administrative, the result is full
privilege escalation and access to restricted functionality.

## Severity

- Rating: Critical
- Rationale: Direct disclosure of a privileged account password.

## Recommendation

- Enforce authorization server-side so users can access only their own account data.
- Never prefill password fields with real credentials or secrets.
- Ensure passwords are stored hashed and are never rendered back to the client.
- Add access-control tests to cover user-controlled identifier tampering (IDOR/BOLA).

## Retest Plan

- Confirm `/my-account?id=administrator` returns a blocked response for non-admin users.
- Confirm password fields are never populated with real credential values.
