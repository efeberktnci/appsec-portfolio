# Lab: Remote code execution via web shell upload (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-12

## Summary
The avatar upload feature stores user-supplied files on the server without validation. By uploading a PHP web shell,
an attacker can execute arbitrary commands on the server and read sensitive files such as `/home/carlos/secret`.

## Steps to Reproduce
1. Log in as `wiener:peter`.
2. On **My account**, use the avatar upload feature to upload a PHP web shell (example: `shell.php`).
3. After upload, locate the uploaded file path (in this lab it is under `/files/avatars/`).
4. Request the uploaded shell with a command parameter to read the secret file:
   - Example: `?cmd=cat /home/carlos/secret`
5. Copy the returned secret value and submit it via the lab banner.

## Evidence
0) Web shell used (`shell.php`):
![Basic PHP web shell used for the upload](assets/00-web-shell-php.png)

1) Avatar upload with `shell.php` selected:
![My account page showing the avatar upload form with shell.php selected](assets/01-upload-avatar-shell-php.png)

2) Server confirms the file is uploaded (path disclosed):
![Upload success message disclosing avatars/shell.php](assets/02-upload-success-message.png)

3) Executing a command via the web shell to read `/home/carlos/secret`:
![Web shell execution output showing the secret contents](assets/03-shell-read-secret.png)

## Impact
Unrestricted file upload leading to server-side code execution can result in full compromise of the application and host
(data theft, credential access, persistence, lateral movement).

## Severity
- Rating: Critical
- Rationale: Direct remote code execution on the server.

## Recommendation
- Validate uploads server-side (allowlist extensions and MIME types).
- Store uploads outside the web root and serve them via a handler (no direct execution).
- Rename files on upload and strip user-controlled paths.
- Disable script execution in upload directories (server config).
- Add malware/content scanning where appropriate.

## Retest Plan
- Attempt to upload executable scripts (e.g., `.php`) and verify they are rejected.
- Verify uploaded files are not directly accessible/executable under a web-served directory.
- Confirm the app does not disclose predictable upload paths.
