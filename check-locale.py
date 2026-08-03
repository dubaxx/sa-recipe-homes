#!/usr/bin/env python3
"""Check src/locale/en/strings.cfg against the prototypes and settings the mod defines.

A missing key shows up in game as "Unknown key: ..." on the tooltip, and nothing in the data stage catches it.
Run from the repository root: python3 check-locale.py
"""

import re
import sys

data = open("src/data.lua").read()
settings = open("src/settings.lua").read()
cfg = open("src/locale/en/strings.cfg").read()


def section(name):
    match = re.search(r"\[" + name + r"\]\n(.*?)(?=\n\[|\Z)", cfg, re.S)
    return set(re.findall(r"^([^\s=]+)=", match.group(1), re.M)) if match else set()


recipes = set(re.findall(r'name = "(sarh-[a-z0-9-]+)"', data))
setting_names = set(re.findall(r'name = "(sarh-[a-z0-9-]+)"', settings))

string_values = {}
for block in re.findall(r"\{(.*?)\n  \}", settings, re.S):
    name = re.search(r'name = "([^"]+)"', block)
    allowed = re.search(r"allowed_values = \{([^}]*)\}", block)
    if name and allowed:
        string_values[name.group(1)] = re.findall(r'"([^"]+)"', allowed.group(1))

checks = [
    ("recipe-name", recipes),
    ("mod-setting-name", setting_names),
    ("mod-setting-description", setting_names),
    ("string-mod-setting", {f"{k}-{v}" for k, values in string_values.items() for v in values}),
]

failed = False
for name, needed in checks:
    have = section(name)
    missing, stale = sorted(needed - have), sorted(have - needed)
    print(f"[{name}] need {len(needed)}  missing: {missing or 'none'}  stale: {stale or 'none'}")
    failed = failed or missing or stale

sys.exit(1 if failed else 0)
