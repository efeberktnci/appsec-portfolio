# Lab: Basic SSRF against the local server (internal scan 192.168.0.X:8080) (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Lab Description

This lab uses the same vulnerable `stockApi` pattern as the basic SSRF lab, but the admin interface is no longer on
`localhost`. Instead, it is hosted somewhere inside the `192.168.0.X` internal range on port `8080`.

Goal: abuse the backend to scan the internal subnet, find the host exposing `/admin`, and use SSRF again to delete
`carlos`.

## Overview (why this works)

Here SSRF is used for **internal service discovery**, not just direct access to one known endpoint. Because the backend
is willing to fetch attacker-controlled URLs, we can iterate through the internal range and observe which response looks
different from the generic failure responses.

Burp Intruder is useful in this lab because the vulnerable request pattern stays the same while only one octet changes:

`stockApi=http://192.168.0.X:8080/admin`

Once the responding host is identified, the attack continues exactly like the simpler SSRF lab: fetch the admin page,
locate the delete path, and trigger it through the vulnerable stock-check feature.

## Summary

The stock-check feature fetches a URL from a user-controlled parameter (`stockApi`). By abusing this, we can force the
backend to scan the internal `192.168.0.X` range for an admin interface on port `8080`, then use the discovered
internal admin endpoint to delete `carlos`.

## Steps to Reproduce

1. Intercept the stock-check request (`POST /product/stock`) in Burp and send it to Intruder.
2. In the request body, place the Intruder position in the final IP octet and build the target pattern:
   - `stockApi=http://192.168.0.§x§:8080/admin`
3. Configure the payload to iterate from `1` to `255`.
4. Start the attack and compare response length/status/content until one response stands out as the real admin page.
5. Send a direct SSRF request to that discovered host:
   - `stockApi=http://192.168.0.<hit>:8080/admin`
6. From the returned admin page, identify the delete action for `carlos`.
7. Trigger the delete action through SSRF:
   - `stockApi=http://192.168.0.<hit>:8080/admin/delete?username=carlos`
8. Confirm the request succeeds and the lab is solved.

## Evidence

1) Baseline stock-check request captured before turning it into a subnet scan:

![Baseline stock check request captured in Burp](assets/04-ssrf-02-01-stock-check-capture-v2.png)

2) Burp Intruder configured to brute-force the final octet in `192.168.0.X:8080/admin`:

![Intruder configured to scan 192.168.0.X:8080](assets/04-ssrf-02-02-intruder-setup.png)

3) Intruder results reveal the outlier response that identifies the internal host exposing the admin panel:

![Intruder results highlighting the discovered internal host](assets/04-ssrf-02-03-intruder-range-scan.png)

4) After reusing the winning host directly, the SSRF response returns the internal admin page:

![Admin interface exposed by the discovered internal host](assets/04-ssrf-02-04-admin-found.png)

5) The final SSRF request triggers the admin delete action for `carlos`:

![SSRF request triggering delete action on internal host](assets/04-ssrf-02-05-delete-carlos.png)

## Impact

SSRF can be used for internal network discovery, access to hidden services, privilege escalation through internal admin
interfaces, and cloud metadata abuse. Once an attacker can make the server scan and talk to internal hosts, the attack
surface becomes much larger than the public application itself.

## Severity

- Rating: Critical
- Rationale: Internal network reachability combined with privileged internal admin access and a destructive action.

## Recommendation

- Allowlist outbound destinations and validate the resolved IP is not private, loopback, or link-local.
- Re-validate redirect targets and disable unnecessary redirects.
- Apply egress filtering so the application cannot reach internal subnets or metadata endpoints.
- Prefer indirect identifiers instead of raw URLs where possible.

## How to test the fix

- Confirm private ranges such as `192.168.0.0/16`, `10.0.0.0/8`, and `172.16.0.0/12` are blocked.
- Test alternative encodings and redirect chains to private IPs.
- Verify the feature still works only for the intended stock backend.

## Retest Plan

- Confirm requests to private ranges such as `192.168.0.0/16`, `10.0.0.0/8`, and `172.16.0.0/12` are blocked.
- Confirm only expected stock service destinations remain reachable.
