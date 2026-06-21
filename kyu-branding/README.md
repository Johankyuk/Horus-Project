# kyu-branding

Identidad del sistema Kyu OS empaquetada para pacman.

## Qué hace

- `/usr/lib/os-release` + symlink `/etc/os-release` → NAME="Kyu OS", ID=kyuos
- `/etc/lsb-release` → DISTRIB_ID="KyuOS"
- `/etc/issue` → banner violeta "Kyu OS" en el TTY
- `/etc/fastfetch/config.jsonc` → logo ASCII KYU OS en violeta (#8B20D4)
- Hook de pacman: si `filesystem` o `lsb-release` se actualizan y pisan
  los archivos, el branding se re-aplica solo. Cero mantenimiento.

## Build e instalación

```bash
cd kyu-branding
makepkg -si
```

Verificar:

```bash
cat /etc/os-release   # NAME="Kyu OS"
fastfetch             # logo KYU OS violeta
```

> Nota: si ya tienes `~/.config/fastfetch/config.jsonc`, ese gana sobre
> `/etc/fastfetch/`. Bórralo o copia el logo ahí.

## Arranque en negro (sin Plymouth)

No se instala plymouth. En la entrada de Limine
(`/boot/limine.conf` o `limine.cfg` según versión), agregar a la línea
de cmdline del kernel:

```
quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0
```

- `quiet loglevel=3` → silencia el kernel salvo errores
- `systemd.show_status=auto` → systemd solo habla si algo falla
- `rd.udev.log_level=3` → silencia udev en el initramfs
- `vt.global_cursor_default=0` → sin cursor parpadeando en negro

Resultado: pantalla negra del bootloader directo a SDDM sugar-dark-kyu.
Si algo truena, los errores SÍ aparecen (eso es lo que queremos: negro,
no ciego).

## Desinstalar

```bash
sudo pacman -R kyu-branding
sudo pacman -S filesystem lsb-release   # restaura identidad original
```
