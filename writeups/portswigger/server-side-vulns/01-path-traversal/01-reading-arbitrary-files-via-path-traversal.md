# Reading arbitrary files via path traversal (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy (lab/material)
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Lab Description

This lab demonstrates how a file-serving endpoint can become vulnerable when it reads a filesystem path directly from a
user-controlled parameter.

Goal: use traversal sequences to escape the intended directory and read an arbitrary file such as `/etc/passwd`.

## Overview (why this works)

Path traversal happens when the application trusts a filename or path fragment supplied by the user and appends it to a
server-side base path without proper validation. If the backend accepts sequences such as `../`, the attacker can move
up the directory tree and reach files outside the intended folder.

For example, an endpoint that normally serves:

```http
GET /loadImage?filename=218.png
```

may become vulnerable if it also accepts:

```http
GET /loadImage?filename=../../../etc/passwd
```

## Summary

When an application builds a filesystem path by appending a user-controlled `filename` parameter to a base directory
without proper validation, an attacker can use traversal sequences like `../` to read files outside the intended
folder.

## Steps to Reproduce

1. Identify an endpoint that retrieves a file by name, such as:
   - `/loadImage?filename=218.png`
2. Intercept or replay the request in Burp.
3. Replace the normal filename with a traversal payload:
   - `../../../etc/passwd`
4. Send the modified request.
5. Confirm that the response contains the contents of `/etc/passwd`, proving arbitrary file read.

## Example request

```http
GET /loadImage?filename=../../../etc/passwd HTTP/2
Host: <lab-host>
```

## Evidence

Example request pattern:
- `GET https://<lab-host>/loadImage?filename=../../../etc/passwd`

Expected response indicators:
- `HTTP/2 200 OK`
- Body contains OS-style account entries such as `root:x:0:0:...`

## Impact

Reading arbitrary files can expose credentials, API keys, configuration files, source code, OS metadata, and secrets
that may enable follow-on attacks such as authentication bypass, RCE chains, or lateral movement.

## Severity

- Rating: High (often High/Critical depending on what can be read)
- Rationale: Direct access to sensitive server-side files.

## Recommendation

- Do not directly append user input to filesystem paths.
- Canonicalize and validate the final resolved path before use.
- Enforce an allowlist of permitted file identifiers instead of raw user-supplied paths.
- Consider using indirect references and storing files outside publicly accessible locations.

## How to test the fix

- Retry `../`, URL-encoded traversal, double-encoded traversal, and Windows-style `..\\` payloads.
- Confirm the resolved path never escapes the intended directory.
- Verify only explicitly allowed files can be served.

## Retest Plan

- Verify traversal sequences (`../`, URL-encoded variants, Windows `..\\`) no longer escape the intended directory.
- Verify only allowed file IDs/names can be retrieved and access is authorized.
