# Access control (PortSwigger) — core concepts (notes)

## What is access control?
Access control defines who is allowed to perform an action or access a resource. In web apps it depends on:
- Authentication: who the user is
- Session management: which requests belong to that user
- Authorization (access control): what the user is allowed to do

## Common failure modes (high signal)
- Missing authorization checks on sensitive endpoints (admin URLs, privileged actions)
- “Security by obscurity” (hiding admin URL but not enforcing authorization)
- Client-side controlled roles/permissions (cookies, hidden fields, query params)
- IDOR/BOLA: user-controlled identifiers accessing other users' resources

## How I test (mental model)
1. Enumerate sensitive actions (admin panel, delete user, view API keys, change email/password).
2. Try direct object access (guess endpoints, use `robots.txt`, search JS, follow links).
3. Tamper identifiers and role indicators (params, cookies, headers).
4. Validate with evidence: response status, returned data, side effects.

This file is intentionally “notes only” (no evidence required). Evidence is added in each `Lab:` write-up.
