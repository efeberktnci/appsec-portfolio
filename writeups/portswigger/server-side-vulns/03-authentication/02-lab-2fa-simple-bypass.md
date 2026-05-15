# Lab: 2FA simple bypass (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Lab Description

This lab implements a two-factor authentication step after password login, but the application does not consistently
enforce completion of that step before serving the authenticated account page.

Goal: access Carlos's account without providing his 2FA code.

## Overview (why this works)

The application correctly prompts for a second factor after the username/password step, but it fails to bind access to
`/my-account` to a server-side “2FA complete” state. In practice, this means the session becomes usable too early.

The key observation in this lab is that we can first log in as our own user, complete 2FA normally, and learn the exact
account-page URL pattern (`/my-account?id=<username>`). Then, when logging in as Carlos, we stop at the 2FA prompt and
reuse that same URL pattern with Carlos's identifier. Because the backend does not strictly enforce the 2FA checkpoint,
the victim account page loads anyway.

## Summary

The application enforces 2FA during login, but the post-login account page (`/my-account`) can still be requested
directly before the second factor is verified. As a result, an attacker with valid credentials can bypass 2FA and
access the victim account.

## Steps to Reproduce

1. Log in with your own account (`wiener:peter`).
2. Open the in-lab email client, retrieve the 4-digit security code, and complete the normal 2FA flow.
3. After login succeeds, open `My account` and observe the account-page URL pattern:
   - `/my-account?id=<username>`
4. Log out from your own account.
5. Log in again, this time using the victim credentials `carlos:montoya`.
6. When the application prompts for the 2FA code, do **not** enter any code.
7. While still at the 2FA checkpoint, manually change the URL in the address bar:
   - reuse the known `/my-account?id=...` pattern
   - replace your own identifier with the victim identifier, for example `id=carlos`
8. Load the page and confirm that Carlos's account page is accessible without completing 2FA.

## Attack Narrative

This bypass works because the application is relying on the user’s navigation flow instead of a strict server-side
authorization state. In a secure design, reaching the password step should not be enough to access authenticated pages;
the session should remain restricted until 2FA is explicitly completed.

In this lab, the normal flow gives us everything we need:
- our own login proves what a valid post-2FA account URL looks like,
- the victim login proves that the password is accepted,
- and the 2FA prompt creates a false sense of protection even though the account page is still reachable directly.

## Evidence

1) Our own login reaches the 2FA checkpoint before code submission:

![2FA prompt shown after the first login step](assets/02-2fa-01-2fa-prompt.png)

2) We retrieve the 2FA security code from the in-lab email client and complete the normal flow for our own account:

![Email client containing the 2FA security code](assets/02-2fa-02-email-code.png)

3) We then attempt to log in as Carlos. The password step succeeds and the application moves us to the 2FA screen:

![Logging in with victim credentials (carlos)](assets/02-2fa-03-login-carlos-creds.png)

4) While still on the victim's 2FA checkpoint, we already know the post-login account URL format and can reuse it:

![2FA step URL after logging in as the victim](assets/02-2fa-04-carlos-2fa-url.png)

5) Direct navigation to `/my-account?id=carlos` works even though no victim 2FA code was submitted:

![Bypass by navigating directly to the account page](assets/02-2fa-05-bypass-my-account.png)

6) Result: Carlos's account page is exposed, confirming that 2FA can be bypassed through direct URL access:

![Victim account page loaded (bypass confirmed)](assets/02-2fa-06-carlos-account-page.png)

## Impact

2FA bypass makes the second factor ineffective. Any attacker who already has valid credentials—through phishing,
credential reuse, password spraying, or prior disclosure—can access the victim account without possessing the one-time
security code.

## Severity

- Rating: Critical
- Rationale: A core authentication defense is fully bypassed, enabling direct account takeover.

## Recommendation

- Bind a server-side `2FA-complete` state to the authenticated session.
- Deny access to authenticated pages until that state is explicitly set.
- Re-check authorization on every sensitive request instead of trusting the user’s navigation flow.
- Add integration tests for direct URL access during incomplete 2FA sessions.

## How to test the fix

- Attempt to access `/my-account` before completing 2FA and verify the request is denied or redirected.
- Repeat the bypass attempt in a new tab and by manually editing the URL.
- Confirm the account page only becomes available after successful second-factor verification.

## Retest Plan

- Verify `/my-account` is inaccessible until the session is marked `2FA-complete`.
- Verify opening the account page in a new tab, changing the URL manually, or replaying the request all fail
  consistently.
