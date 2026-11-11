# ZeroKVM — GitMariorg fork

This repository is a personal/community-maintained fork of [doominator42/ZeroKVM](https://github.com/doominator42/ZeroKVM), an open-source KVM-over-IP implementation using a DisplayLink-compatible USB gadget.

**Upstream:** https://github.com/doominator42/ZeroKVM
**License:** GNU GPL-3.0-or-later. The upstream `LICENSE` and `NOTICE` files are retained unchanged.

## Fork changes

This fork contains local EDID-related changes intended to improve the display mode negotiation observed with a Raspberry Pi Zero 2 W:

- `src/ZeroKvm/Program.cs`: sets EDID manufacturer ID `0xD041` and product ID `0x0001`.
- `src/ZeroKvm/Edid.cs`: when `DigitalSync` is initialized, sets bits 60 and 59 in the timing descriptor.

These are empirical changes, not a proven explanation of the DisplayLink host's EDID handling. See [EDID notes](docs/EDID.md) for the test observations and limitations.

## Tested configuration

| Item | Observed configuration |
|---|---|
| Board | Raspberry Pi Zero 2 W |
| OS | Raspberry Pi OS Lite, 64-bit; Debian 13 (trixie), aarch64 |
| Build | .NET 10 Native AOT, built natively on the Pi |
| Reported display result | 1600×900; correct aspect ratio and comfortable desktop use |
| Build result | `dotnet publish` completed successfully; see [build instructions](docs/BUILD.md) |

The 1600×900 result is a user-observed test result on the setup above. It is not a claim that every host, DisplayLink driver, or monitor will select this mode.

## Documentation

- [Русская инструкция](README.ru.md)
- [Build from source](docs/BUILD.md)
- [Installation and service setup](docs/INSTALL.md)
- [EDID investigation and known result](docs/EDID.md)
- [Instructions for AI coding agents](AGENTS.md)
- [Contribution notes](CONTRIBUTING.md)

## Upstream project

The original project and its protocol research are maintained by Dominic Germain at [doominator42/ZeroKVM](https://github.com/doominator42/ZeroKVM). This fork is not presented as the upstream project. Please report upstream-specific issues to the original repository and fork-specific changes here.

## License and notices

This project is distributed under the GNU General Public License, version 3 or (at your option) any later version. See the unmodified [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE) files. Preserve upstream copyright and license notices in redistributed copies and derivative works.
