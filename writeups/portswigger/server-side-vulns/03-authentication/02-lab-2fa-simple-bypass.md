# Lab: 2FA simple bypass (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Summary
The application enforces 2FA during login, but the post-login account page (`/my-account`) can be accessed without
completing the 2FA step. As a result, an attacker with valid credentials can bypass 2FA and access the victim's account.

## Steps to Reproduce
1. Log in with your own account (`wiener:peter`).
2. Open the **Email client**, retrieve the 4-digit security code, and complete 2FA.
3. After successful login, open **My account** and note the URL pattern (for example: `/my-account?id=<username>`).
4. Log out.
5. Log in using the victim credentials (`carlos:montoya`).
6. When prompted for the 2FA code, **do not** enter a code.
7. Manually edit the URL to the account page you observed earlier:
   - Keep the same `/my-account?...` path/query format.
   - Replace the username (or id) value with the victim's username (for example: `id=carlos`).
8. Load the page. If the victim's account page loads, 2FA is bypassed and the lab is solved.

## Evidence
1) Victim login reaches the 2FA checkpoint (no victim code available):
![2FA prompt shown after entering victim credentials](assets/02-2fa-01-2fa-prompt.png)

2) Email client shows the normal 2FA code delivery for the low-priv user:
![Email client containing the 2FA security code (for the low-priv user)](assets/02-2fa-02-email-code.png)

3) Victim credentials accepted (password step passes) and the 2FA prompt is shown:
![Logging in with victim credentials (carlos)](assets/02-2fa-03-login-carlos-creds.png)

4) We are still at the 2FA URL/step:
![2FA step URL after logging in as the victim](assets/02-2fa-04-carlos-2fa-url.png)

5) Bypass: manually navigate to the victim's account page URL without submitting a 2FA code:
![Bypass by navigating directly to /my-account while still at the 2FA step](assets/02-2fa-05-bypass-my-account.png)

6) Result: victim's account page loads (bypass confirmed):
![Victim account page loaded (bypass confirmed)](assets/02-2fa-06-carlos-account-page.png)



## Impact
2FA bypass leads to account takeover whenever an attacker obtains valid credentials (phishing, credential stuffing, reuse).

## Severity
- Rating: Critical
- Rationale: 2FA is rendered ineffective; direct unauthorized access to accounts is possible.

## Recommendation
- Enforce 2FA server-side by binding a "2FA-complete" state to the session.
- Block access to authenticated pages until 2FA is completed.
- Re-check authorization on every request; do not rely on client-side navigation.
- Add tests: attempt to access `/my-account` with a session that is not 2FA-complete (should be denied/redirected).

## Retest Plan
- Verify `/my-account` is inaccessible until the session is marked 2FA-complete.
- Verify bypass attempts (direct URL, opening in new tabs, replaying requests) fail consistently.
