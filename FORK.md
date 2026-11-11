# Fork provenance and modifications

This repository is a modified version of [doominator42/ZeroKVM](https://github.com/doominator42/ZeroKVM).

- Upstream project author and copyright notice: Dominic Germain; see the original `NOTICE`.
- Upstream license: GNU GPL version 3 or (at your option) any later version; see the original `LICENSE`.
- Fork-specific changes recorded on 2026-11-11:
  - `src/ZeroKvm/Program.cs`: EDID manufacturer ID `0xD041` and product ID `0x0001`.
  - `src/ZeroKvm/Edid.cs`: `DigitalSync` initialization sets bits 60 and 59.
  - English/Russian documentation, build/install instructions, and AI-agent guidance.

The upstream `LICENSE` and `NOTICE` files are retained verbatim. The fork does not claim authorship of upstream code. The EDID changes are empirical and their exact causal effect has not been isolated; see `docs/EDID.md`.
