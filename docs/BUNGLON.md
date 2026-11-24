# Bunglon 🦎 — Kompatibilitas Aplikasi & Game

Bunglon membuat Puzzle tetap **terminal-only saat boot**, tapi bisa menjalankan
aplikasi/game desktop **kapan pun dibutuhkan** dengan cara:

1. Cari nama di database (`/etc/bunglon/apps.conf` atau `games.conf`).
2. `pacman -S --needed` paket + dependensinya (prompt bawaan Arch).
3. Nyalakan display (Xvfb + VNC, atau startx + openbox).
4. Jalankan aplikasi/game yang **benar-benar asli**.

## Perintah

| Perintah | Fungsi |
|---|---|
| `run <nama>` | unduh + jalankan aplikasi desktop |
| `play <nama>` | unduh + jalankan game |
| `/menu/start` | Start Menu berisi semua fitur (lihat screenshot) |
| `/taskbar-all` | tampilkan taskbar |
| `go-to-taskbar/<nama>` | pin aplikasi ke taskbar |
| `/uninstalled b- <nama>` | uninstall aplikasi + buang dari taskbar |

Perintah dengan `/` ditangkap oleh `command_not_found_handle`
(`/etc/profile.d/bunglon.sh`) lalu diteruskan ke `bunglon dispatch`.

## Start Menu (`/menu/start`)

Menu Windows dari screenshot dipetakan ke:

| Menu | Perintah Puzzle |
|---|---|
| Installed apps | `bunglon apps` |
| Mobility Center | `bunglon mobility` |
| Power Options | `bunglon power` |
| Event Viewer | `bunglon logs` |
| System | `bunglon system` |
| Device Manager | `bunglon devices` |
| Network Connections | `bunglon net` |
| Disk Management | `bunglon disk` |
| Computer Management | `bunglon manage` |
| Terminal | `bash` |
| Terminal (Admin) | `sudo -i` |
| Task Manager | `bunglon task` (btop/htop) |
| Settings | `bunglon settings` |
| File Explorer | `bunglon files` (ranger/lf/mc) |
| Search | `bunglon search <kata>` |
| Run | `run <nama>` |
| Shut down or sign out | `bunglon power` |
| Desktop | `bunglon desktop` |

## Taskbar

Daftar pin disimpan di `~/.config/bunglon/taskbar` (satu aplikasi per baris).
Taskbar juga muncul di status bar tmux:

```
[ Puzzle ] firefox code supertux | 10:42
```

## Database aplikasi

Edit `assets/etc/bunglon/apps.conf` (sebelum build) atau
`/etc/bunglon/apps.conf` (di dalam ISO):

```
nama|paket-arch|dependensi,koma,terpisah
firefox|firefox|mesa,ttf-dejavu
```

Format sama untuk `games.conf`. Kalau nama tidak ada di database,
Bunglon memakai nama itu sebagai paket Arch langsung.

### Catatan repo

- `steam` butuh **multilib** (aktifkan `[multilib]` di `pacman.conf`).
- `minecraft`/`code` butuh **AUR** (misal `yay`/`paru`) — Bunglon memakai `pacman`,
  jadi kalau paketnya AUR, install manual dulu atau tambahkan helper AUR ke resep.

## Mode tampilan

- **vnc** (default): Puzzle tetap headless. Buka `vnc://<IP>:5900` dari HP/PC.
- **local**: Bunglon menyalakan X + openbox di layar langsung.

Ubah di `/etc/bunglon.conf` atau lewat `bunglon settings`.
