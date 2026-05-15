# Lab: Basic SSRF against the local server (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Lab Description

This lab exposes a stock-check feature that fetches data from a URL supplied by the user.

Goal: turn that feature into a server-side request to `localhost`, access the internal admin panel, and delete
`carlos`.

## Overview (why this works)

The vulnerable parameter is `stockApi`. Instead of restricting it to a known stock backend, the application allows the
user to control the full destination URL. Because the fetch is performed by the backend server, the request originates
from the server’s internal network position, not from the external attacker’s browser.

That changes the trust boundary completely. Endpoints such as `http://localhost/admin` are normally intended to be
reachable only from the local machine, but SSRF allows the attacker to make the application itself request them.

## Summary

The stock-check feature takes a user-controlled URL parameter (`stockApi`) and the backend fetches it server-side. By
changing this URL to `http://localhost/admin`, we can force the server to access an internal-only admin interface. From
there, we can trigger the delete action for `carlos`.

## Steps to Reproduce

1. Intercept the stock-check request (`POST /product/stock`) in Burp.
2. Identify the backend-fetch parameter `stockApi`.
3. Replace the normal stock-service URL with the internal admin endpoint:
   - `stockApi=http://localhost/admin`
4. Send the modified request and inspect the response body.
5. Confirm the response now contains the internal admin page and the link or path used to delete `carlos`.
6. Send a second SSRF request that targets the delete endpoint directly:
   - `stockApi=http://localhost/admin/delete?username=carlos`
7. Confirm the request succeeds and the lab is solved.

## Example exploitation flow

```http
POST /product/stock
stockApi=http://localhost/admin
```

Then:

```http
POST /product/stock
stockApi=http://localhost/admin/delete?username=carlos
```

## Evidence

1) Baseline stock-check request captured in Burp before tampering:

![Baseline stock check request (captured in Burp)](assets/01-stock-check-request.png)

2) After replacing the stock backend URL with `http://localhost/admin`, the application returns the internal admin
panel through the stock-check feature:

![Admin interface retrieved via SSRF to localhost](assets/02-localhost-admin-panel.png)

3) A second SSRF request is used to call the delete action for `carlos`, and the response shows the admin-side
redirect that confirms the action:

![SSRF request triggering delete action and 302 redirect](assets/03-delete-carlos-redirect.png)

## Impact

SSRF can grant access to internal-only services such as admin panels, internal APIs, localhost-only tooling, and cloud
metadata endpoints. In real environments, this frequently leads to privilege escalation, secret exposure, lateral
movement, and infrastructure compromise.

## Severity

- Rating: High (often Critical depending on the internal target)
- Rationale: Attacker-controlled server-side requests reach internal privileged endpoints and perform admin actions.

## Recommendation

- Allowlist outbound targets and validate the resolved IP is not loopback, private, or link-local.
- Disable or strictly validate redirects in server-side fetch features.
- Add network egress controls so the application server cannot access internal admin services from this feature.
- Prefer indirect resource identifiers over raw user-supplied URLs.

## How to test the fix

- Try `localhost`, `127.0.0.1`, `::1`, and private IP destinations and verify the requests are blocked.
- Test encoded or alternative localhost forms to confirm they are rejected consistently.
- Confirm the stock-check feature can reach only the intended stock backend.

## Retest Plan

- Verify requests to `localhost`, `127.0.0.1`, and private IP ranges are blocked.
- Verify only approved stock endpoints can be fetched and responses are validated.
