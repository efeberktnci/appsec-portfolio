# Redeemer

![Platform: Hack The Box](https://img.shields.io/badge/Platform-Hack%20The%20Box-9FEF00?style=for-the-badge) ![Type: Starting Point](https://img.shields.io/badge/Type-Starting%20Point-3B5BDB?style=for-the-badge) ![Difficulty: Very Easy](https://img.shields.io/badge/Difficulty-Very%20Easy-2F9E44?style=for-the-badge) ![Status: Solved](https://img.shields.io/badge/Status-Solved-2F9E44?style=for-the-badge)

Lab link: [Redeemer](https://app.hackthebox.com/starting-point)

## Completion proof

![Completion proof](assets/01-completion-proof.png)

## Flag retrieval

![Flag retrieval in Redis](assets/02-flag-retrieval.png)

## What I did

1. Scanned the target from Pwnbox with Nmap. The default scan covered the most common 1,000 TCP ports and showed no open port.
2. Scanned the full TCP port range with `nmap -p- <target-ip>` and found Redis on `6379/tcp`.
3. Connected to the service with `redis-cli -h <target-ip> -p 6379`.
4. Checked Redis information and saw `db0:keys=4` in the keyspace section. `KEYS *` listed four keys, including `flag`.
5. Briefly switched to database 1, where reading `flag` returned `(nil)`. The `1)` beside `flag` in the key list was its list position, not a database number.
6. Returned to database 0 with `SELECT 0` and read the value with `GET flag` to complete the lab.

The flag value is intentionally omitted from this write-up.
