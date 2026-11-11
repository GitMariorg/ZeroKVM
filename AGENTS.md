# Instructions for AI coding agents

## Project identity and provenance

- This repository is a fork of https://github.com/doominator42/ZeroKVM.
- Keep the upstream attribution visible. Do not claim authorship of upstream code.
- `LICENSE` and `NOTICE` are inherited upstream files. Do not remove, replace, or rewrite them.
- The project is GPL-3.0-or-later. When distributing modified versions, comply with the GPL and retain required notices.

## Before changing code

1. Read `README.md`, `README.ru.md`, `docs/EDID.md`, and the relevant upstream documentation.
2. Inspect the current source and Git diff. Do not assume that old chat summaries describe the current tree.
3. Separate confirmed observations from hypotheses. Never describe an empirical workaround as a proven protocol fix without evidence.
4. Keep changes narrow. Do not reformat unrelated upstream code.
5. Do not commit build outputs (`bin/`, `obj/`), secrets, private keys, certificates, logs, or machine-specific configuration.

## Build and test

- The known target is Raspberry Pi Zero 2 W, Raspberry Pi OS Lite 64-bit / Debian 13 (trixie), aarch64.
- Follow `docs/BUILD.md`. The tested native build uses .NET 10, `linux-arm64`, one MSBuild worker, and disabled shared compilation.
- A successful compile does not prove USB/EDID behavior. Hardware validation requires installing the binary, restarting the service, reconnecting the USB cable/device, and checking the host's actual active signal mode.
- Do not claim tests were run unless the relevant command output or hardware result is available in the current task.
- If testing on another architecture or OS, label it separately.

## EDID-specific caution

- Current fork changes: `ManufacturerId = 0xD041`, `ManufacturerProduct = 0x0001`, and `DigitalSync` sets bits 60 and 59.
- The observed useful result was 1600×900 on one Windows host/setup.
- A Windows registry query still showed a 256-byte DisplayLink fallback EDID (`Manufacturer 11 8D`, `Product 00 00`, name `?USB_4010-`). Therefore do not claim that Windows was proven to consume the custom EDID.
- Read `docs/EDID.md` before modifying these fields. Preserve the evidence and uncertainty in documentation.

## Documentation

- Keep the English and Russian README files aligned.
- Document exact commands, prerequisites, and tested environments.
- Mark unverified steps as unverified; do not invent package versions, device IDs, timings, or expected results.
- Update `CHANGELOG.md` when behavior or supported setup changes.
