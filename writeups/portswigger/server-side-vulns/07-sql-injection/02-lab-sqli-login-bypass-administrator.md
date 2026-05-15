# Lab: SQL injection vulnerability in login function (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-12

## Lab Description

This lab contains a SQL injection vulnerability in the login function.

Goal: authenticate as the `administrator` user without knowing the password.

## Overview (why this works)

The login query is built unsafely using attacker-controlled input from the username field. By submitting:

`administrator'--`

the payload closes the intended string after `administrator` and comments out the remainder of the query, including the
password check. If the backend query is built through string concatenation, this turns normal authentication into a
simple SQLi-based login bypass.

## Summary

The login function is vulnerable to SQL injection in the `username` parameter. By terminating the username string and
commenting out the rest of the query, we can force the application to authenticate as `administrator` without knowing a
password.

## Steps to Reproduce

1. Open the login page.
2. In the `Username` field, enter:
   - `administrator'--`
3. Leave the password field blank or enter any value.
4. Submit the form.
5. Confirm the application logs you in as `administrator`.
6. Verify the account page loads and the lab is solved.

## Query logic

Conceptually, the vulnerable backend may be doing something like:

```sql
SELECT * FROM users WHERE username = '<input>' AND password = '<input>'
```

With the injected username, the resulting logic becomes equivalent to:

```sql
SELECT * FROM users WHERE username = 'administrator'--' AND password = '<anything>'
```

The comment sequence disables the rest of the original query, so the password condition is no longer enforced.

## Evidence

1) The payload `administrator'--` is placed directly into the username field on the login form:

![Login form showing the injected username payload](assets/02-01-login-payload-admin-comment.png)

2) After submission, the application authenticates the session as `administrator` and displays the account page:

![My account page showing username administrator](assets/02-02-admin-account-page.png)

## Impact

SQL injection in authentication logic can lead to complete account takeover, including administrative access. In real
applications, that frequently means full application compromise.

## Severity

- Rating: Critical
- Rationale: Authentication bypass as an administrative user.

## Recommendation

- Use parameterized queries / prepared statements for authentication.
- Never construct SQL with string concatenation.
- Apply safe password handling, rate limiting, monitoring, and account protection controls.

## How to test the fix

- Re-test classic login payloads such as `administrator'--`, `' OR 1=1--`, and encoded variants.
- Confirm the backend treats them as plain input and the password check cannot be bypassed.

## Retest Plan

- Verify payloads like `administrator''--`, `' OR 1=1--`, and `admin'--` do not change authentication behavior.
- Confirm the backend uses parameterized queries and no SQL errors leak to users.
