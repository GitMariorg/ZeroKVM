# EDID investigation and current empirical workaround

## Original symptom

On the tested Windows hosts, Windows showed a desktop mode of 1920×1080 at 60 Hz while the active signal mode was 1280×1024 at 60 Hz. This caused incorrect aspect ratio/letterboxing and mouse-coordinate offset in the ZeroKVM web view.

The Windows device inventory distinguished the laptop's internal panel from the DisplayLink device:

- Internal panel: `DISPLAY\AUO5699\...`, 1920×1080.
- DisplayLink device: `DISPLAY\DLM0000\...`, reported as a generic monitor / no monitor, 1280×1024.
- USB device: `USB\VID_17E9&PID_4010...`.
- DisplayLink driver observed: `11.5.6380.0`.

A registry EDID query for the DisplayLink monitor returned 256 bytes and showed:

- Manufacturer bytes: `11 8D`
- Product bytes: `00 00`
- Name: `?USB_4010-`
- Checksum over the first 128-byte block: zero

This looked like a DisplayLink fallback EDID, not clear proof that the custom EDID from ZeroKVM had been accepted.

## Fork modifications

Two source files differ from upstream:

1. `src/ZeroKvm/Program.cs`
   - `ManufacturerId = 0xD041`
   - `ManufacturerProduct = 0x0001`

2. `src/ZeroKvm/Edid.cs`
   - `TimingDescriptor.DigitalSync` sets bit 60 and bit 59 when initialized to `true`.

The preferred timing descriptor in `Program.cs` still describes 1920×1080. The EDID also sets established-timing flags for 640×480, 800×600 and 1024×768, and includes four standard-timing entries. See Program.cs for their exact encoded values.

## Observed result

After rebuilding and installing the modified binary, restarting ZeroKVM, and reconnecting the USB device, the user reported that Windows presented 1600×900 and that the aspect ratio was correct and comfortable to use.

This is a practical success on the tested setup. It does **not** establish which individual source change caused the result, nor prove that Windows consumed the custom EDID. The subsequent registry query still showed the fallback-like values above.

## Troubleshooting / future experiments

When changing EDID code, change one variable at a time where possible and record:

- Host OS build and DisplayLink driver version.
- Windows desktop mode and active signal mode.
- Device instance / hardware ID.
- Raw EDID bytes and checksum, not only the friendly monitor name.
- ZeroKVM build commit and binary timestamp/hash.
- Whether the USB device was physically reconnected after service restart.

Do not remove the manufacturer/product values or alter the `DigitalSync` bits without retesting the actual host behavior. Do not document a protocol-level explanation as fact until the EDID bytes requested by the host and the resulting mode negotiation have been verified.
