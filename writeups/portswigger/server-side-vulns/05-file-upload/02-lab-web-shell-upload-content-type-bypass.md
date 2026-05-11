# Lab: Web shell upload via Content-Type bypass (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-12

## Summary
The avatar upload feature attempts to restrict uploads to images only, but it relies on **user-controllable** metadata
(the `Content-Type` value in the multipart request) to validate file type. By changing `Content-Type` to `image/jpeg`,
it's possible to upload a PHP web shell and read `/home/carlos/secret`.

## Steps to Reproduce
1. Log in as `wiener:peter` and go to **My account** (avatar upload).
2. Prepare a basic PHP web shell (example below) and save it as `shell.php`:
   - `<?php echo file_get_contents('/home/carlos/secret'); ?>`
3. Try uploading `shell.php` normally via the avatar form. The upload is rejected because the server checks MIME type
   (for example it blocks `application/octet-stream`).
4. In Burp, locate the `POST /my-account/avatar` request and send it to **Repeater**.
5. In Repeater, in the multipart section for the file upload, change the file part header:
   - From: `Content-Type: application/octet-stream`
   - To: `Content-Type: image/jpeg`
6. Send the modified request. The server accepts the upload and responds with the uploaded path (for example:
   `avatars/shell.php`).
7. Open the uploaded avatar path under `/files/avatars/shell.php`.
   - In the browser flow shown here, right-clicking the uploaded avatar and opening it in a new tab returns the secret directly.
8. Copy the secret value and submit it via the lab banner to solve the lab.

## Evidence
1) PHP web shell used (reads `/home/carlos/secret`):
![PHP web shell source](assets/02-01-web-shell-source.png)

2) My account avatar upload form with `shell.php` selected:
![My account upload form](assets/02-02-my-account-upload-form.png)

3) Server rejects the first upload attempt because the file part is `application/octet-stream`:
![shell.php selected](assets/02-03-shell-selected.png)

4) Burp HTTP history shows the failed `POST /my-account/avatar` request (`403`):
![Upload rejected](assets/02-04-upload-rejected-octet-stream.png)

5) Repeater copy of the upload request still has `Content-Type: application/octet-stream` in the file part:
![Proxy HTTP history showing avatar fetch](assets/02-05-proxy-history-avatar-fetch.png)

6) After changing the file part to `Content-Type: image/jpeg`, the server returns `200 OK` and uploads `avatars/shell.php`:
![Repeater upload request with octet-stream](assets/02-06-repeater-upload-octet-stream.png)

7) The successful Repeater request/response confirms the bypass path:
![Repeater upload request with image/jpeg](assets/02-07-repeater-upload-image-jpeg.png)

8) Opening `/files/avatars/shell.php` in a new tab returns Carlos's secret:
![Uploaded web shell returning the secret](assets/02-08-open-uploaded-shell-secret.png)

## Impact
Bypassing file upload restrictions can enable remote code execution and full server compromise (read/write files, steal
secrets, pivot to other internal systems).

## Severity
- Rating: Critical
- Rationale: Uploading executable code leads to server-side code execution / sensitive file disclosure.

## Recommendation
- Do not trust user-supplied `Content-Type`. Perform server-side validation using content sniffing and allowlists.
- Store uploads outside the web root and serve them via an image handler (never directly execute uploads).
- Enforce non-executable permissions and disable script execution in upload directories.
- Randomize/rename uploaded files and avoid reflecting predictable paths to users.

## Retest Plan
- Attempt to upload `.php` again while spoofing `Content-Type`; verify the server rejects it.
- Verify `/files/avatars/` cannot execute or interpret scripts (uploads are treated as inert content only).
