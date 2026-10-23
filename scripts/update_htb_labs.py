"""Keep the portfolio's HTB lab lists in sync with completed lab write-ups."""

from pathlib import Path
import re
import subprocess


ROOT = Path(__file__).resolve().parents[1]
LABS = ROOT / "writeups/hackthebox/Labs"


def latest_labs():
    entries = []
    for readme in LABS.glob("*/README.md"):
        relative = readme.relative_to(ROOT).as_posix()
        result = subprocess.run(
            ["git", "log", "-1", "--format=%ct", "--", relative],
            cwd=ROOT, capture_output=True, text=True, check=True,
        )
        timestamp = int(result.stdout.strip() or "0")
        entries.append((timestamp, readme.parent.name))
    return [name for _, name in sorted(entries, key=lambda x: (-x[0], x[1].lower()))]


def replace_once(path, pattern, replacement):
    original = path.read_text(encoding="utf-8")
    updated, count = re.subn(pattern, lambda _: replacement, original, count=1, flags=re.M)
    if count != 1:
        raise RuntimeError(f"Expected one matching section in {path}")
    if updated != original:
        path.write_text(updated, encoding="utf-8", newline="\n")
        print(f"Updated {path.relative_to(ROOT)}")
        return True
    return False


def main():
    labs = latest_labs()
    featured = " · ".join(
        f"[{name}](writeups/hackthebox/Labs/{name}/)" for name in labs[:3]
    )
    row = (
        '| <img src="writeups/hackthebox/assets/hackthebox-logo.jpg" width="18" '
        'height="18" alt="Hack The Box logo" /> **Hack The Box** | '
        '[writeups/hackthebox/](writeups/hackthebox/) | '
        f"{featured} |"
    )
    changed = replace_once(
        ROOT / "README.md",
        r"^\| <img src=\"writeups/hackthebox/assets/hackthebox-logo.jpg\".*$",
        row,
    )
    changed |= replace_once(
        ROOT / "writeups/hackthebox/README.md",
        r"(?<=- \[Labs\]\(Labs/\)\n)(?:  - \[[^\n]+\n)*",
        "".join(f"  - [{name}](Labs/{name}/)\n" for name in labs),
    )
    changed |= replace_once(
        LABS / "README.md",
        r"(?<=# Hack The Box Labs\n\n)(?:- \[[^\n]+\n)*",
        "".join(f"- [{name}]({name}/)\n" for name in labs),
    )
    return 0


if __name__ == "__main__":
    main()
