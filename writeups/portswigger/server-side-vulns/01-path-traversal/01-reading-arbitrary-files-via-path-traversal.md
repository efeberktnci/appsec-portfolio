# Reading arbitrary files via path traversal (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy (lab/material)
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Summary
When an application builds a filesystem path by appending a user-controlled `filename` (or similar) to a base directory
without proper validation, an attacker can use traversal sequences like `../` to read files outside the intended folder.

## Steps (high-level)
1. Identify an endpoint that fetches a file by name, e.g. `/loadImage?filename=218.png`.
2. Replace the `filename` parameter with a traversal payload, e.g. `../../../etc/passwd`.
3. Confirm the response contains the targeted file contents.

## Evidence (sanitized)
Example request pattern (sanitized):
- `GET https://<lab-host>/loadImage?filename=../../../etc/passwd`

Expected result:
- Response includes contents of `/etc/passwd`.

## Impact
Reading arbitrary files can expose credentials, API keys, configuration, source code, and other sensitive data. This often
enables further attacks (e.g., authentication bypass, RCE chains, or lateral movement).

## Severity
- Rating: High (often High/Critical depending on what can be read)
- Rationale: Direct access to sensitive server-side files.

## Recommendation
- Do not directly append user input to filesystem paths.
- Canonicalize and validate the final path, then enforce an allowlist of permitted files/IDs.
- Use indirect references (IDs stored server-side) instead of raw filenames.
- Consider storing files outside the web root and applying strict authorization checks.

## Retest Plan
- Verify traversal sequences (`../`, URL-encoded variants, Windows `..\\`) no longer escape the intended directory.
- Verify only allowed file IDs/names can be retrieved and access is authorized.
