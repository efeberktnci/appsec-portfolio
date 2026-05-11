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
2. Open the in-lab **Email client**, read the 4-digit 2FA code, and complete 2FA.
3. After successful login, go to **My account** and copy/record the account page URL format:
   - Example format: `/my-account?id=<username>`
   - This URL is reachable after login when 2FA is completed.
4. Log out.
5. Log in using the victim credentials (`carlos:montoya`).
6. When the application prompts for the 2FA code, **do not** enter any code.
7. In the browser address bar, use the URL format you copied in step 3 and update only the username/id value to the victim:
   - Example: change `id=wiener` to `id=carlos`
8. Load the page. If Carlos's account page loads, you have bypassed 2FA.

## Evidence
1) Victim login reaches the 2FA checkpoint (no victim code available):
![2FA prompt shown after entering victim credentials](assets/02-2fa-01-2fa-prompt.png)

2) Low-priv user receives a 2FA code via the in-lab email client:
![Email client containing the 2FA security code (for the low-priv user)](assets/02-2fa-02-email-code.png)

3) Victim credentials are accepted (password step passes), then the 2FA prompt is shown:
![Logging in with victim credentials (carlos)](assets/02-2fa-03-login-carlos-creds.png)

4) We are still on the 2FA step URL (2FA not completed):
![2FA step URL after logging in as the victim](assets/02-2fa-04-carlos-2fa-url.png)

5) Bypass: manually navigate to `/my-account` with the victim's username/id (without entering any 2FA code):
![Bypass by navigating directly to /my-account while still at the 2FA step](assets/02-2fa-05-bypass-my-account.png)

6) Result: victim's account page loads (2FA bypass confirmed):
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
