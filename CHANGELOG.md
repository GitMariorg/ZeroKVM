# Changelog

## Fork baseline — 2026-11-11

- Fork baseline: upstream `doominator42/ZeroKVM`, commit `72efe2cdc83bfea9090199624ad7de6c4e810eda` (full local history fetched; four commits were present in the supplied checkout).
- Preserve two existing local EDID modifications:
  - Set EDID manufacturer ID to `0xD041` and product ID to `0x0001`.
  - Set bits 60 and 59 when initializing `TimingDescriptor.DigitalSync`.
- Recorded the user-observed 1600×900 result on Raspberry Pi Zero 2 W.
- Added English/Russian project documentation and AI-agent guidance.

The EDID behavior remains empirical; see `docs/EDID.md`.
