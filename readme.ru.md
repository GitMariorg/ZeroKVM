# ZeroKVM — форк GitMariorg

Личный форк [doominator42/ZeroKVM](https://github.com/doominator42/ZeroKVM) — KVM-over-IP на базе USB-гаджета, совместимого с DisplayLink.

**Оригинальный проект:** https://github.com/doominator42/ZeroKVM  
**Лицензия:** GNU GPL-3.0-or-later. Оригинальные файлы `LICENSE` и `NOTICE` сохранены без изменений.

## Что изменено в форке

Добавлены экспериментальные изменения EDID для практической работы с Raspberry Pi Zero 2 W:

- `src/ZeroKvm/Program.cs`: Manufacturer ID `0xD041`, Product ID `0x0001`.
- `src/ZeroKvm/Edid.cs`: при установке `DigitalSync` выставляются биты 60 и 59 дескриптора тайминга.

Это эмпирические изменения. Их точный механизм влияния на согласование режима DisplayLink пока не доказан. Подробности и ограничения — в [документе EDID](docs/EDID.md).

## Проверенная конфигурация

| Параметр | Значение |
|---|---|
| Плата | Raspberry Pi Zero 2 W |
| ОС | Raspberry Pi OS Lite 64-bit, Debian 13 (trixie), aarch64 |
| Сборка | .NET 10 Native AOT непосредственно на Raspberry Pi |
| Практический результат | 1600×900; правильные пропорции, пользоваться комфортно |
| Сборка | `dotnet publish` завершилась успешно |

Результат 1600×900 подтверждён пользователем на одной конфигурации. Это не гарантия такого же режима на любом компьютере, драйвере DisplayLink или дисплее.

## Документы

- [Сборка из исходников](docs/BUILD.md)
- [Установка и systemd](docs/INSTALL.md)
- [История EDID и известный результат](docs/EDID.md)
- [Инструкции для AI-агентов](AGENTS.md)
- [Правила изменений](CONTRIBUTING.md)

## Авторство и лицензия

Оригинальный проект создан Dominic Germain и находится в [doominator42/ZeroKVM](https://github.com/doominator42/ZeroKVM). Этот репозиторий — отдельный форк, а не оригинальный upstream-проект.

Распространение — GNU GPL версии 3 или, по выбору пользователя, любой более поздней версии. См. оригинальные файлы [`LICENSE`](LICENSE) и [`NOTICE`](NOTICE). Не удаляйте и не изменяйте исходные уведомления об авторских правах и лицензии.
