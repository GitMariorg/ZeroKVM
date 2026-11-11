# Install on Raspberry Pi OS / Debian with systemd

These notes describe the service layout used by the upstream project and the tested Pi setup. Review the paths before applying them to a different system.

## USB device mode

For Raspberry Pi boards, configure the USB controller in peripheral/device mode in `/boot/firmware/config.txt`:

```ini
dtoverlay=dwc2,dr_mode=peripheral
```

Ensure the `libcomposite` module is loaded. The repository provides `systemd/usb-gadget.conf` containing:

```text
libcomposite
```

The upstream systemd guide also calls for copying this file to `/etc/modules-load.d/`.

## Install binary and service

Build the binary as described in [BUILD.md](BUILD.md), then:

```bash
sudo install -m 0755 ~/ZeroKVM/bin/linux-arm64/zerokvm /usr/bin/zerokvm
sudo install -D -m 0644 ~/ZeroKVM/systemd/usb-gadget.conf /etc/modules-load.d/usb-gadget.conf
sudo install -D -m 0644 ~/ZeroKVM/systemd/zerokvm.service /usr/lib/systemd/system/zerokvm.service
sudo systemctl daemon-reload
sudo systemctl enable zerokvm
sudo systemctl restart zerokvm
```

Check service state and logs:

```bash
systemctl status zerokvm --no-pager
journalctl -u zerokvm -b --no-pager -n 100
```

The service listens on HTTP port 80 and HTTPS port 443, redirects HTTP to HTTPS, and auto-creates a certificate at the configured certificate paths when needed. The default service command is defined in `systemd/zerokvm.service`.

The web interface is available at:

```text
https://<PI_IP>/
```

The default certificate is self-signed; the browser may show a certificate warning. This setup is intended for a trusted local network, not direct public exposure. Do not expose the service to the Internet without adding an appropriate authentication and network-security layer.

## USB connection and validation

Connect the Pi's USB OTG/device port to the host. After changing the EDID implementation, restart the service and reconnect the USB device so the host re-enumerates it. Check both the desktop resolution and the active signal mode in the host OS. Record the DisplayLink driver version and EDID evidence when troubleshooting.
