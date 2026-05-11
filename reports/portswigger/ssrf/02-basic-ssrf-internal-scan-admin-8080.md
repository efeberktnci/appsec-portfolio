# SSRF: Internal network scan via stock check (192.168.0.X:8080) (Full Finding Report)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Summary
The stock check functionality fetches a URL specified by the client (`stockApi`). Because the backend performs these
requests server-side without strict allowlisting or IP-range protections, an attacker can use SSRF to scan internal
network ranges (here, `192.168.0.X` on port `8080`) for internal admin interfaces. Once found, the attacker can access the
internal admin UI and execute privileged actions (deleting users).

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

## Evidence (sanitized)
Baseline request capture:

![Baseline stock check request captured in Burp](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-01-stock-check-capture-v2.png)

Intruder internal range scan (`192.168.0.X:8080`) showing the successful hit:

Intruder setup:

![Intruder configured to scan 192.168.0.X:8080](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-02-intruder-setup.png)

Intruder results (hit):

![Intruder results highlighting the discovered internal host](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-03-intruder-range-scan.png)

Admin interface retrieved via SSRF (example hit):

![Admin interface fetched from internal host via SSRF](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-04-admin-found.png)

Delete action triggered via SSRF (redirect after deletion):

![SSRF request triggering delete action on internal host](../../../writeups/portswigger/server-side-vulns/04-ssrf/assets/04-ssrf-02-05-delete-carlos.png)

## Impact
SSRF enables attackers to make the server initiate requests to unintended targets. This often allows:
- Discovery of internal services (internal port scanning via response/status/timing)
- Access to internal-only admin panels and APIs
- Credential exposure via cloud metadata services
- Follow-on compromise if internal services trust the source network

In this case, internal admin functionality is reachable and destructive actions are possible.

## Severity
- Rating: Critical
- Rationale: Internal network scanning + internal admin access + privileged action execution.

## Recommendation
### Primary controls
- Implement a strict allowlist for outbound destinations required by the stock-check feature (exact domains/paths).
- Resolve DNS and block requests to loopback/link-local/private ranges:
  - IPv4: `127.0.0.0/8`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `169.254.0.0/16`
  - IPv6: loopback and private ranges
- Disable redirects, or re-validate the destination after each redirect hop.

### Defense in depth
- Enforce egress network controls: this feature should not be able to reach internal subnets or metadata endpoints.
- Set timeouts and request limits to reduce SSRF-based scanning.
- Log and alert on attempts to reach blocked/internal destinations.

## Retest Plan
- Attempt SSRF to private ranges, loopback, and URL-encoded variants; verify blocks are enforced after DNS resolution.
- Attempt redirect-based bypass; verify redirects cannot reach internal targets.
- Confirm stock check continues to work for allowlisted endpoints only.

## Executive Summary (5–10 lines)
The stock check feature fetches a client-supplied URL server-side, enabling server-side request forgery (SSRF). An attacker
can use this to scan internal IP ranges (192.168.0.X) on port 8080 to discover internal admin interfaces, then access the
admin UI and execute privileged actions such as deleting users. This is critical because it breaks internal network
trust boundaries and can expose sensitive internal services or cloud metadata. Fix by allowlisting outbound destinations,
blocking private/loopback/link-local IP ranges after DNS resolution, disabling unsafe redirects, and enforcing egress
network controls. Add monitoring and regression tests to prevent reintroduction.
