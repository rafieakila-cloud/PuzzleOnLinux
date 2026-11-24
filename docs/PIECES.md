# Format Keping & Resep 🧩

## Keping (`pieces/<nama>.piece`)

File keping adalah **shell script yang di-source**. Definisikan variabel ini:

```bash
PIECE_NAME="nama"          # wajib, unik
PIECE_TITLE="Judul"
PIECE_DESC="Deskripsi singkat"
PIECE_REQUIRED=0           # 1 = wajib (base)
PIECE_PACKAGES=(pkg1 pkg2) # paket Arch yang dipasang
PIECE_SERVICES=(svc.service)# (opsional, dokumentasi)
PIECE_ASSETS=(             # berkas dari assets/ yang disalin ke ISO
  usr/local/bin/scriptku
  etc/konfigurasi.conf
)
PIECE_NOTES="Catatan"
```

### Aset

`PIECE_ASSETS` berisi path **relatif terhadap folder `assets/`**. Path itu juga menjadi tujuan di dalam ISO. Contoh:

```
assets/usr/local/bin/bunglon  →  /usr/local/bin/bunglon di ISO
assets/etc/bunglon.conf       →  /etc/bunglon.conf di ISO
```

Semua aset otomatis chmod 755 saat disalin.

### Keping otomatis

Kalau kamu mengetik:

```bash
./puzzle add htop
```

dan `pieces/htop.piece` belum ada, Puzzle akan **membuatkan keping otomatis** yang berisi paket `htop`. Jadi semua paket di repo Arch bisa langsung jadi keping.

## Resep (`recipes/<nama>.recipe`)

```bash
RECIPE_NAME="namaku"
RECIPE_DESC="Deskripsi"
PIECES=( base bash network tools )
```

- `base` wajib (tidak bisa di-`remove`).
- Resep yang ada (`minimal`, `developer`, `server`, `bunglon`) **hanya contoh**.
- Buat resep baru: `./puzzle init namaku`.

## Daftar keping bawaan

| Keping | Isi |
|---|---|
| `base` | kernel, firmware, dasar Arch (wajib) |
| `bash` | shell default + prompt |
| `network` | dhcpcd, iproute2, iputils, wpa_supplicant |
| `tools` | curl, git, ripgrep, fzf, htop, tmux, micro, zoxide |
| `dev` | base-devel, gdb, cmake, python, nodejs, go |
| `server` | openssh, tcpdump, screen, socat |
| `docs` | man-db, man-pages, texinfo |
| `installer` | archinstall, gptfdisk, e2fsprogs |
| `multimedia` | ffmpeg, mpv, cmus, imagemagick |
| `security` | gnupg, openssl, nmap, tcpdump |
| `containers` | podman, docker-cli, buildah, skopeo |
| `database` | sqlite, postgresql, redis |
| `cloud` | rclone, aws-cli, restic |
| `fun` | figlet, lolcat, cowsay, neofetch, cmatrix |
| `system` | btop, ncdu, duf, lsd, bat, eza |
| `bunglon-core` | Bunglon + database aplikasi + handler perintah |
| `bunglon-play` | Bunglon Play + database game |
| `bunglon-menu` | tool untuk Start Menu & taskbar |
| `kernel-studio` | perintah `kernel` untuk otak-atik kernel |
| `auto-setup` | hostname, locale, timezone, DHCP, user, sudo, mirror (boot pertama) |
| `gui-builder` | `gui build/start/stop` — GUI on-demand, boot tetap terminal |
| `pro-tools` | `puzzle status/doctor/snapshot/update/repo/splash` |
| `puzzle-info` | `puzzlefetch` (fastfetch + logo puzzle & kunci inggris), btop/htop |
| `hacking-coding` | `hack scan/ports/sniff/wifi/hash/dns`, `code new/build/run` |
