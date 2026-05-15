# Lab: File path traversal, simple case (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-11

## Lab Description

This lab contains an image-loading function that reads a file path directly from a user-controlled `filename` parameter.
The application does not properly restrict the path to the intended image directory, so traversal sequences can break out
of that directory and reach arbitrary files on the server.

Goal: retrieve `/etc/passwd` by tampering with the `filename` parameter.

## Overview (why this works)

The backend expects a normal request such as:

```http
GET /loadImage?filename=218.png
```

If the application simply appends the provided value to a filesystem path without canonical validation, traversal
sequences like `../` can escape the images directory. In this lab, that allows a direct read of `/etc/passwd`.

## Summary

The application fetches product images using a user-controlled `filename` parameter. Because the server does not validate
or restrict the path, an attacker can use traversal sequences to retrieve arbitrary files from the filesystem.

## Steps to Reproduce (high-level)

1. Intercept a request that fetches a product image in Burp.
2. Identify the user-controlled `filename` parameter.
3. Replace the normal image name with the traversal payload `../../../etc/passwd`.
4. Forward the request and inspect the response body.
5. Confirm that the response contains the contents of `/etc/passwd`, which solves the lab.

### Example vulnerable request

```http
GET /loadImage?filename=../../../etc/passwd HTTP/2
Host: <lab-host>
```

## Evidence

Request:
- `GET https://<lab-host>/loadImage?filename=../../../etc/passwd`

Response indicators:
- `HTTP/2 200 OK`
- Body contains lines resembling `root:x:0:0:...`

## Impact

Arbitrary file read can expose secrets, configuration files, source code, and OS-level information that may enable
follow-on compromise.

## Severity

- Rating: High
- Rationale: Direct sensitive file disclosure from the server filesystem.

## Recommendation

- Use indirect references (image IDs) and map them to safe file paths server-side.
- Canonicalize and validate the resolved path before file access.
- Enforce that the final resolved path stays inside an allowlisted upload/image directory.
- Add regression tests for traversal payloads, encoded traversal, and Windows path variants.

## Retest Plan

- Confirm traversal payloads such as `../`, URL-encoded traversal, and Windows-style traversal cannot escape the image directory.
- Verify only expected image files can be loaded and arbitrary server files are never returned.
