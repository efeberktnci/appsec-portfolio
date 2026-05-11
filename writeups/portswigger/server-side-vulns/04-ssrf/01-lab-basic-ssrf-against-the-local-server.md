# Lab: Basic SSRF against the local server (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Summary
The stock check feature takes a user-controlled URL parameter (`stockApi`) and the backend fetches it server-side.
By changing this URL to `http://localhost/admin`, we can force the server to access an internal-only admin interface.
From there, we can trigger an admin action to delete the user `carlos`.

## Steps to Reproduce (high-level)
1. Intercept the stock check request (e.g., `POST /product/stock`) in Burp.
2. Identify the backend-fetch parameter (here: `stockApi`).
3. Change it to the internal admin endpoint:
   - `stockApi=http://localhost/admin`
4. In the response, find the delete action for `carlos` (e.g., `/admin/delete?username=carlos`).
5. Send a second request that triggers the delete action via SSRF:
   - `stockApi=http://localhost/admin/delete?username=carlos`
6. Confirm the server responds with a redirect (e.g., `302 Found` to `/admin`) and the lab is solved.

## Evidence
Baseline stock check request:
- `assets/01-stock-check-request.png`

![Baseline stock check request (captured in Burp)](assets/01-stock-check-request.png)

Admin interface accessed via SSRF:
- `assets/02-localhost-admin-panel.png`

![Admin interface retrieved via SSRF to localhost](assets/02-localhost-admin-panel.png)

Delete action triggered via SSRF (redirect after deletion):
- `assets/03-delete-carlos-redirect.png`

![SSRF request triggering delete action and 302 redirect](assets/03-delete-carlos-redirect.png)

## Impact
SSRF can grant access to internal-only services (admin panels, metadata endpoints, internal APIs). This can lead to data
exposure, privilege escalation, and in some environments full infrastructure compromise.

## Severity
- Rating: High (often Critical depending on internal target)
- Rationale: Attacker-controlled server-side requests reach internal-only endpoints and perform privileged actions.

## Recommendation (short)
- Allowlist outbound targets (domain/endpoint) and validate the resolved IP is not private/loopback.
- Disable or strictly validate redirects.
- Apply network egress controls so the app cannot reach internal admin services/metadata from this feature.

## Retest Plan
- Verify requests to `localhost`, `127.0.0.1`, private IP ranges, and URL-encoded variants are blocked.
- Verify only approved stock endpoints can be fetched and responses are in expected format.
