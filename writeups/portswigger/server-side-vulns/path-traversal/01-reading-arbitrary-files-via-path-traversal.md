# Reading arbitrary files via path traversal (PortSwigger)

## Mini Lab Report
- Goal: Understand how path traversal allows reading files outside the intended directory.
- Lab/Topic: Path traversal → reading arbitrary files
- Finding: User-controlled `filename` is used to build a filesystem path without validation.
- Evidence (sanitized): Request uses traversal sequences like `../../../etc/passwd` (Linux) or `..\\..\\..\\windows\\win.ini` (Windows).
- Impact: Attacker can read sensitive files on the server (credentials, keys, configs), potentially enabling further compromise.
- Fix idea: Canonicalize paths + allowlist filenames/IDs; block `../` / `..\\`; store files outside web root; enforce authorization.
- What I learned: “Joining paths” is not safe when user input is appended; always validate after canonicalization.

## Notes
- This write-up is based on the learning material. For a “full finding report”, include a sanitized request/response snippet from your solved lab instance.
