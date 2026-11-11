# Build from source

## Tested target

The tested target is Raspberry Pi Zero 2 W with Raspberry Pi OS Lite 64-bit (Debian 13 / trixie, `aarch64`). The project uses .NET 10 Native AOT. The successful build was performed natively on the Pi.

## Prerequisites

Install the native build dependencies:

```bash
sudo apt update
sudo apt install -y clang xxd libaio-dev libturbojpeg0-dev
```

Install the .NET 10 SDK for Debian/Raspberry Pi OS using Microsoft's official instructions:
https://learn.microsoft.com/dotnet/core/install/linux-debian

Check the toolchain:

```bash
dotnet --info
clang --version
uname -m
```

Expected architecture for this build: `aarch64`.

## Memory consideration

Native AOT compilation is memory-intensive on a Pi Zero 2 W (512 MB RAM). The successful build used an 8 GB swap file. Swap setup is system administration and can wear flash storage; use suitable storage and remove/disable temporary swap if it is no longer needed. The exact swap creation method is intentionally not prescribed here because it depends on the existing swap configuration.

Check available memory and swap before building:

```bash
free -h
swapon --show
```

## Known-good publish command

Run from the repository root:

```bash
cd ~/ZeroKVM

DOTNET_CLI_TELEMETRY_OPTOUT=1 \
DOTNET_gcServer=0 \
dotnet publish src/ZeroKvm/ZeroKvm.csproj \
  -c Release \
  -r linux-arm64 \
  -o ~/ZeroKVM/bin/linux-arm64 \
  -m:1 \
  -p:BuildInParallel=false \
  -p:UseSharedCompilation=false
```

The recorded successful run completed in approximately 831 seconds and produced:

- `src/UsbFfs/bin/Release/net10.0/UsbFfs.dll`
- `bin/linux-arm64/zerokvm`

This is a historical result from the tested Pi, not a performance guarantee.

## Build verification

```bash
test -x ~/ZeroKVM/bin/linux-arm64/zerokvm
file ~/ZeroKVM/bin/linux-arm64/zerokvm
```

Do not commit `bin/` or `obj/` build output. Hardware behavior must be validated separately after installation; see [INSTALL.md](INSTALL.md).
