# Lab: File path traversal, simple case (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Summary
The application fetches product images using a user-controlled `filename` parameter. Because the server does not validate
or restrict the path, an attacker can use traversal sequences to retrieve arbitrary files from the filesystem.

## Steps to Reproduce (high-level)
1. Intercept a request that fetches a product image (Burp Proxy).
2. Modify the `filename` parameter to a traversal payload: `../../../etc/passwd`.
3. Forward the request and observe the response contains the contents of `/etc/passwd`.

## Evidence (sanitized)
Request (sanitized):
- `GET https://<lab-host>/loadImage?filename=../../../etc/passwd`

Response (sanitized indicators):
- `HTTP/2 200 OK`
- Body contains lines resembling: `root:x:0:0:...`

## Impact
Arbitrary file read can expose secrets and configuration and may enable follow-on compromise.

## Severity
- Rating: High
- Rationale: Direct sensitive file disclosure.

## Recommendation
- Use indirect references (image IDs) and map server-side to safe paths.
- Canonicalize + validate the resolved path stays within an allowlisted directory.
- Deny traversal sequences and their encodings; add regression tests for traversal payloads.

## Retest Plan
- Confirm traversal payloads (including URL-encoded and Windows variants) no longer escape the image directory.
