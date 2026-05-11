# SSRF: Basic SSRF against the local server (Full Finding Report)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Summary
The application’s stock check feature fetches a URL provided by the client (`stockApi`). Because the backend performs the
request server-side without proper validation or allowlisting, an attacker can force it to request internal-only URLs such
as `http://localhost/admin`. This exposes internal admin functionality and allows privileged actions (deleting users).

## Steps to Reproduce
1. Navigate to a product page and click **Check stock**.
2. In Burp, capture the request to the stock check endpoint (e.g., `POST /product/stock`).
3. Send the request to Repeater.
4. Modify the `stockApi` parameter to target the internal admin interface:
   - `stockApi=http://localhost/admin`
5. Send the request and observe the response contains admin interface content and a delete action for `carlos`.
6. Modify the parameter to trigger the delete action:
   - `stockApi=http://localhost/admin/delete?username=carlos`
7. Send the request and confirm the server responds with a redirect (e.g., `302 Found` to `/admin`) and the lab marks as solved.

## Evidence (sanitized)
Baseline request capture:
- `writeups/portswigger/server-side-vulns/04-ssrf/assets/01-stock-check-request.png`

![Baseline stock check request captured in Burp](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/01-stock-check-request.png)

Admin interface fetched via SSRF:
- `writeups/portswigger/server-side-vulns/04-ssrf/assets/02-localhost-admin-panel.png`

![Admin interface retrieved via SSRF to localhost](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/02-localhost-admin-panel.png)

Delete action triggered via SSRF (redirect after deletion):
- `writeups/portswigger/server-side-vulns/04-ssrf/assets/03-delete-carlos-redirect.png`

![SSRF request triggering delete action and 302 redirect](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/03-delete-carlos-redirect.png)

## Impact
SSRF enables attackers to make the server initiate requests to unintended targets. This often allows access to:
- Internal-only services (admin panels, internal APIs, monitoring endpoints)
- Cloud metadata services (credential exposure)
- Sensitive data not exposed externally

In this case, internal admin functionality is reachable and destructive actions are possible.

## Severity
- Rating: Critical
- Rationale: Internal admin endpoint access + privileged action execution via attacker-controlled server-side requests.

## Recommendation
### Primary controls
- Use an allowlist for outbound destinations (exact domains/paths required for stock checks).
- Resolve the hostname and block requests to loopback/link-local/private ranges (e.g., `127.0.0.0/8`, `10.0.0.0/8`,
  `172.16.0.0/12`, `192.168.0.0/16`, `169.254.0.0/16`, IPv6 loopback/private).
- Disable redirects, or re-validate the destination after every redirect hop.

### Defense in depth
- Enforce egress firewall rules so this component cannot reach internal admin services or metadata endpoints.
- Add strict timeouts and request limits to prevent SSRF-based scanning.
- Log outbound request attempts and alert on blocked/internal targets.

## Retest Plan
- Attempt SSRF to `localhost`, `127.0.0.1`, private IPs, and URL-encoded variants; verify they are blocked.
- Attempt redirect-based bypass; verify redirects do not allow internal targets.
- Confirm the stock check still works for allowlisted endpoints.

## Executive Summary (5–10 lines)
The stock check feature allows client-controlled URLs to be fetched by the backend. This enables server-side request
forgery (SSRF), letting an attacker access internal-only endpoints such as `http://localhost/admin`. Using SSRF, an
attacker can reach admin functionality and execute privileged actions (e.g., deleting users). The risk is high because
internal services and cloud metadata may be reachable from the application environment. Fix by allowlisting outbound
destinations, blocking private/loopback IP ranges after DNS resolution, disabling unsafe redirects, and enforcing egress
network controls. Add monitoring and tests to prevent regressions.
