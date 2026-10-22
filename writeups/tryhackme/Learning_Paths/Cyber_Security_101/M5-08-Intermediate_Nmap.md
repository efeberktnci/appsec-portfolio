![Last Update](https://img.shields.io/badge/LAST_UPDATE-2026--10--22-5D646F?style=for-the-badge)

# Intermediate Nmap

![TRACK](https://img.shields.io/badge/TRACK-APPSEC-4B5563?style=for-the-badge)
![FOCUS](https://img.shields.io/badge/FOCUS-TRYHACKME-0EA5E9?style=for-the-badge)
![PATH](https://img.shields.io/badge/PATH-CYBER_SECURITY_101-7C3AED?style=for-the-badge)
![MODULE](https://img.shields.io/badge/MODULE-M5--08-F59E0B?style=for-the-badge)
![LAST UPDATE](https://img.shields.io/badge/LAST_UPDATE-2026--10--22-111827?style=for-the-badge)

Room link: https://tryhackme.com/room/intermediatenmap

## Challenge completion

This CTF-style challenge combined Nmap enumeration, a direct connection with netcat, SSH authentication, and basic Linux navigation. The room's clue pointed to a high-numbered port that could reveal information useful for a remote-access service. The flag submission was accepted and the room reached 100% completion. The steps below describe the investigation leading up to that result.

## 1) Scanning all TCP ports

The target for this lab session was `Hidden`. Because the clue explicitly mentioned a high port, the scan covered the full TCP port range:

```bash
nmap -sS -p- -T4 --open Hidden
```

`-sS` selects a TCP SYN scan, `-p-` covers ports 1 through 65535, and `-T4` selects the aggressive timing template. `--open` filters the displayed results to open or potentially open ports; it does not reduce the port range being scanned.

The scan returned three open TCP ports:

| Port | Nmap service label |
|---|---|
| Hidden | ssh |
| Hidden/tcp | Hidden |
| Hidden/tcp | Hidden |

The remaining Hidden TCP ports were reported closed. Since this command did not include service-version detection, the service labels were port-based hints rather than verified identities. Port Hidden was selected for the next check because it matched the room's high-port clue.

## 2) Reading the service response with netcat

```bash
nc Hidden Hidden
```

Netcat opened a TCP connection to the selected port. The service returned a message beginning with `Hidden`, followed by a username/password pair for `Hidden`. This supplied credentials to test against the remote-access service discovered during enumeration.

The useful finding was the information exposed by the service response. No password guessing was needed; the challenge deliberately made the credentials available through that connection. The password is Hidden. All Hidden values are redaction placeholders.

## 3) Logging in over SSH

```bash
ssh Hidden@Hidden
```

After accepting the first-connection host-key prompt for the lab host, the password obtained from netcat was entered at the password prompt. SSH does not display typed password characters, so the empty-looking input was expected.

The Hidden welcome banner and remote shell prompt confirmed that authentication succeeded. At this point, subsequent shell commands were running on the target as `Hidden`. Access had been obtained, but the room still required locating and submitting the flag.

## 4) Checking the current directory and hidden files

```bash
pwd
ls
ls -la
```

`pwd` showed `/home/Hidden`. The plain `ls` produced no entries because the directory contained only hidden items. With `ls -la`, files such as `.bashrc`, `.bash_logout`, and `.profile`, plus the `.cache` directory, became visible.

Here, `-l` requests details such as permissions, ownership, and size, while `-a` includes names beginning with a dot. There was no obviously named flag file in this listing, so the next step was to inspect the surrounding directory structure.

## 5) Looking at the parent directory

```bash
ls ..
```

The parent directory contained `Hidden` and `Hidden`. This identified a second home directory to investigate. The navigation step was:

```bash
cd ../Hidden
ls -la
```

`..` means the parent directory, and `../Hidden` refers to its `Hidden` subdirectory. Changing directories with `cd` does not change the logged-in account. Entering a directory name by itself makes the shell try to execute it, while `pwd` only prints the current location; neither action replaces `cd`.

## 6) Submitting the flag

The flag was submitted successfully and the room reached 100%. The flag, its location, and final answer are Hidden.

The challenge connected each finding to the next action: the full-port scan exposed the high-port service, its response supplied credentials, and those credentials enabled SSH access for local file exploration.
