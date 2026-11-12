#!/usr/bin/env bash
set -Eeuo pipefail

REPO="GitMariorg/ZeroKVM"
ASSET="zerokvm-linux-arm64"
EXPECTED_SHA256="f355d541a92503dfb36ed970722a3e6830b86d2e9dae7ca0dc0c5f9eda4fece2"
SERVICE="/etc/systemd/system/zerokvm.service"
MODULES_FILE="/etc/modules-load.d/zerokvm.conf"
CONFIG="/boot/firmware/config.txt"
REBOOT_REQUIRED=0

log() { printf '\n[ZeroKVM] %s\n' "$*"; }
die() { printf '\n[ОШИБКА] %s\n' "$*" >&2; exit 1; }

[[ "$EUID" -eq 0 ]] || die "Запусти установщик через sudo."
[[ "$(uname -m)" == "aarch64" ]] || die "Нужна 64-битная ARM-система (aarch64)."

[[ -r /etc/os-release ]] || die "Не удалось определить ОС."
. /etc/os-release
[[ "${ID:-}" == "raspbian" || "${ID:-}" == "debian" ]] || die "Поддерживаются Raspberry Pi OS / Debian."
[[ -d /sys/firmware/devicetree/base ]] || die "Не обнаружено дерево устройств Raspberry Pi."
[[ -d /run/systemd/system ]] || die "Требуется systemd."

MODEL="$(tr -d '\0' </proc/device-tree/model 2>/dev/null || true)"
[[ "$MODEL" == *"Raspberry Pi"* ]] || die "Устройство не распознано как Raspberry Pi: $MODEL"

GLIBC_VERSION="$(getconf GNU_LIBC_VERSION | awk '{print $2}')"
if [[ "$(printf '%s\n' 2.34 "$GLIBC_VERSION" | sort -V | head -n1)" != "2.34" ]]; then
    die "Нужна glibc версии 2.34 или новее. Обнаружена $GLIBC_VERSION."
fi

log "Устройство: $MODEL"
log "ОС: ${PRETTY_NAME:-Debian}"
log "Архитектура: $(uname -m), glibc $GLIBC_VERSION"

export DEBIAN_FRONTEND=noninteractive
log "Устанавливаем системные утилиты..."
apt-get update
apt-get install -y ca-certificates curl kmod

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

DOWNLOAD_URL="https://github.com/$REPO/releases/latest/download/$ASSET"
log "Скачиваем готовый бинарник из GitHub Releases..."
curl -fL --retry 3 --connect-timeout 15 "$DOWNLOAD_URL" -o "$TMP/$ASSET"

ACTUAL_SHA256="$(sha256sum "$TMP/$ASSET" | awk '{print $1}')"
[[ "$ACTUAL_SHA256" == "$EXPECTED_SHA256" ]] || die "SHA-256 не совпадает! Ожидался $EXPECTED_SHA256, получен $ACTUAL_SHA256."
chmod 0755 "$TMP/$ASSET"
install -m 0755 "$TMP/$ASSET" /usr/bin/zerokvm
log "Бинарник установлен, SHA-256 проверен."

[[ -f "$CONFIG" ]] || die "Не найден $CONFIG. Убедись, что установлена Raspberry Pi OS."
if ! grep -Eq '^[[:space:]]*dtoverlay=dwc2,dr_mode=peripheral([,[:space:]]|$)' "$CONFIG"; then
    cp -a "$CONFIG" "$CONFIG.backup-zerokvm-$(date +%Y%m%d-%H%M%S)"
    if grep -Eq '^[[:space:]]*dtoverlay=dwc2([,[:space:]]|$)' "$CONFIG"; then
        sed -i -E 's|^[[:space:]]*dtoverlay=dwc2[^[:space:]]*|dtoverlay=dwc2,dr_mode=peripheral|' "$CONFIG"
    else
        printf '\n# ZeroKVM: USB OTG device mode\ndtoverlay=dwc2,dr_mode=peripheral\n' >> "$CONFIG"
    fi
    REBOOT_REQUIRED=1
    log "Настроен USB OTG overlay в $CONFIG."
fi

install -d -m 0755 /etc/modules-load.d
cat > "$MODULES_FILE" <<'EOF'
dwc2
libcomposite
EOF

if ! grep -Eq '^[[:space:]]*configfs[[:space:]]+/sys/kernel/config[[:space:]]+configfs([[:space:]]|$)' /etc/fstab; then
    printf '\n# ZeroKVM: configfs for USB gadget\nconfigfs /sys/kernel/config configfs defaults 0 0\n' >> /etc/fstab
fi

mkdir -p /sys/kernel/config
if ! mountpoint -q /sys/kernel/config; then
    mount -t configfs configfs /sys/kernel/config || REBOOT_REQUIRED=1
fi

cat > "$SERVICE" <<'EOF'
[Unit]
Description=ZeroKVM daemon
After=network-online.target
Wants=network-online.target
Requires=sys-kernel-config.mount

[Service]
Type=simple
ExecStart=/usr/bin/zerokvm -l [::]:80 -l [::]:443,tls --https-redirect --cert /etc/zerokvm/cert.pem --cert-key /etc/zerokvm/key.pem --auto-create-cert
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable zerokvm.service

if [[ "$REBOOT_REQUIRED" -eq 1 ]] || ! compgen -G '/sys/class/udc/*' >/dev/null; then
    log "Установка завершена. Требуется перезагрузка для активации USB OTG."
    log "Выполни: sudo reboot"
else
    systemctl restart zerokvm.service
    sleep 2
    if systemctl is-active --quiet zerokvm.service; then
        log "ZeroKVM установлен и запущен."
        systemctl --no-pager --full status zerokvm.service
    else
        systemctl --no-pager --full status zerokvm.service || true
        log "Служба установлена, но не запустилась. Диагностика: journalctl -u zerokvm -b --no-pager"
        exit 1
    fi
fi

log "Веб-интерфейс: https://IP_АДРЕС_RASPBERRY_PI/"
log "По умолчанию используется самоподписанный HTTPS-сертификат.";
