# Lab: Username enumeration via different responses (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Summary
The login endpoint returns different responses for valid vs invalid usernames. This allows an attacker to enumerate a
valid username, then brute-force the password using a wordlist.

## Steps to Reproduce (high-level)
1. Capture a login request (`POST /login`) in Burp and send it to Intruder.
2. **Username enumeration:** mark `username` as the payload position and use the provided candidate usernames wordlist.
3. Identify a valid username based on the different response message (e.g., `Incorrect password` vs `Invalid username`).
4. **Password brute-force:** set `username` to the valid value and mark `password` as the payload position, then run the
   candidate passwords wordlist.
5. Identify the correct password (commonly indicated by a redirect such as `302 Found` to `My account`).
6. Log in with the discovered credentials and access the account page to solve the lab.

## Evidence
- Valid username identified: `asterix` (response differs for valid vs invalid usernames).
- Successful password attempt shows a redirect:
  - `302 Found` → `Location: /my-account?id=asterix`

Screenshots:

Baseline request capture (what we send to Intruder):
![Captured baseline login request in Burp (sent to Intruder)](assets/01-login-request-captured.png)

Username enumeration (look for the outlier / different response):
![Username enumeration result (different response for a valid username)](assets/02-username-enum-hit.png)

Password brute-force (success is usually a redirect, e.g. `302`):
![Password brute-force result showing a 302 redirect (successful login)](assets/03-password-bruteforce-302.png)

Verification (the account page loads after logging in):
![Account page loaded after logging in](assets/04-account-page.png)

## Impact
Username enumeration significantly reduces the effort needed for brute-force attacks and increases account takeover risk.

## Severity
- Rating: High
- Rationale: Enables account compromise when combined with weak passwords and missing rate limiting/lockout.

## Recommendation
- Use generic error messages for authentication failures (same wording for user and password failures).
- Add rate limiting, progressive delays, and/or account lockout with safe thresholds.
- Add bot defenses (CAPTCHA / device fingerprinting) where appropriate.
- Monitor and alert on repeated failed logins and credential-stuffing patterns.

## Retest Plan
- Verify invalid and valid usernames produce indistinguishable responses (status, body, timing within noise).
- Verify brute-force attempts are slowed/blocked and generate alerts.
