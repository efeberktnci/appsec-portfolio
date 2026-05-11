# SSRF: Internal network scan via stock check (192.168.0.X:8080) (Full Finding Report)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Summary
The stock check feature fetches a URL provided by the client (`stockApi`). Because the backend performs these requests
server-side without strict allowlisting and without blocking internal destinations, an attacker can use SSRF to scan an
internal IP range (`192.168.0.X`) on port `8080` for an admin interface. Once a responding host is found, the attacker can
fetch the admin UI and trigger privileged actions (in the lab: delete the user `carlos`).

## Why this is worse than “basic SSRF”
This variant turns SSRF into an internal discovery primitive:
- Internal port scanning by response status/length/timing
- Service enumeration (finding admin endpoints)
- Pivoting to internal trust boundaries (services that are not exposed externally)

In real environments, this is often how SSRF chains start before moving to credentials, lateral movement, or infra impact.

## Steps to Reproduce
1. Navigate to a product page and click **Check stock**.
2. In Burp, capture the request to the stock check endpoint (e.g., `POST /product/stock`) and send it to Intruder.
3. Mark the final octet as a payload position and set:
   - `stockApi=http://192.168.0.§x§:8080/admin`
4. Configure payloads to iterate `x` from `1..255` and start the attack.
5. Identify the host that returns a successful response (e.g., `200 OK`) for `/admin`.
6. In Repeater, request the admin page via SSRF:
   - `stockApi=http://192.168.0.<hit>:8080/admin`
7. Trigger the delete action for `carlos` via SSRF:
   - `stockApi=http://192.168.0.<hit>:8080/admin/delete?username=carlos`
8. Confirm the server responds with a redirect (e.g., `302 Found` back to `/admin`) and the lab is solved.

## Evidence
Baseline request capture:

![Baseline stock check request captured in Burp](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-01-stock-check-capture-v2.png)

Intruder setup (range scan):

![Intruder configured to scan 192.168.0.X:8080](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-02-intruder-setup.png)

Intruder results (hit):

![Intruder results highlighting the discovered internal host](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-03-intruder-range-scan.png)

Admin interface fetched via SSRF:

![Admin interface fetched from internal host via SSRF](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-04-admin-found.png)

Delete action triggered via SSRF (redirect after deletion):

![SSRF request triggering delete action on internal host](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-05-delete-carlos.png)

## Impact
SSRF can enable:
- Internal network scanning and service discovery
- Access to internal-only admin panels and APIs
- Secret retrieval from internal endpoints
- Cloud metadata targeting (identity/credential exposure)

The practical business risk is loss of confidentiality (internal data), integrity (admin actions), and availability (SSRF-driven scanning/DoS).

## Severity
- Rating: Critical
- Rationale: Internal network scanning + internal admin access + privileged action execution.

## Recommendation
### Primary controls (do these first)
- Use a strict allowlist for outbound destinations required by the stock-check feature (exact domains/paths).
- Resolve DNS and block requests to loopback/link-local/private ranges (IPv4 + IPv6), including:
  - `127.0.0.0/8`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `169.254.0.0/16`
- Disable redirects, or re-validate the destination after every redirect hop.
- Restrict URL schemes to `http`/`https` only.

### Defense in depth
- Enforce egress network controls so this feature cannot reach internal subnets/metadata endpoints.
- Add strict timeouts and request limits to reduce SSRF-based scanning.
- Add logging/alerting for blocked or suspicious destinations (private IPs, link-local, unusual ports).
- Prefer an internal proxy service with centralized policy for outbound requests (where appropriate).

## Retest Plan
- Attempt SSRF to private ranges, loopback, and URL-encoded variants; verify blocks are enforced after DNS resolution.
- Attempt redirect-based bypass; verify redirects cannot reach internal targets.
- Confirm stock check continues to work for allowlisted endpoints only.

## Executive Summary (5–10 lines)
The stock check feature fetches a client-supplied URL server-side, enabling SSRF. By iterating over `192.168.0.X:8080`,
an attacker can scan internal hosts to discover an admin interface, then fetch the admin UI and execute privileged actions
such as deleting users. This is critical because it breaks internal network trust boundaries and enables discovery and
exploitation of internal services that are not exposed externally. Fix by allowlisting outbound destinations, blocking
private/loopback/link-local IPs after DNS resolution, disabling unsafe redirects, and enforcing egress network controls.
Add monitoring and tests to prevent regressions.
