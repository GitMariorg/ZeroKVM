# Contributing

This is a fork of [doominator42/ZeroKVM](https://github.com/doominator42/ZeroKVM). Contributions should preserve upstream attribution and the GPL-3.0-or-later licensing terms.

## Scope

- Prefer small, reviewable changes.
- Keep upstream changes distinguishable from fork-specific changes.
- Do not commit generated build output, `bin/`, `obj/`, credentials, certificates, or private configuration.
- For EDID/DisplayLink changes, include the exact host OS, DisplayLink driver version, device identity, selected desktop mode, active signal mode, and relevant EDID evidence where available.

## Validation

For Raspberry Pi Zero 2 W, use the procedure in [docs/BUILD.md](docs/BUILD.md). Hardware claims must include the actual host-side result. A successful build alone is not hardware validation.

## Pull requests

Describe:
1. The problem and reproduction steps.
2. The exact files changed.
3. Build/test commands and their results.
4. Hardware and host configuration, if applicable.
5. Any remaining uncertainty or regression risk.
