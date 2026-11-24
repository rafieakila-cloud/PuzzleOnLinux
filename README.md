# Puzzle On Linux 🧩

> *Rakit sistemmu, keping demi keping.*

**Puzzle On Linux** adalah distro Linux **terminal-only** berbasis **Arch** yang diposisikan sebagai **kotak perakit**, bukan distro "jadi" untuk satu tujuan. Kamu memilih kepingan, Puzzle merakitnya jadi **ISO bootable** untuk VM (VirtualBox/QEMU) maupun flash ke PC.

| Item | Nilai |
|---|---|
| Basis | Arch Linux (`archiso`) |
| Tampilan | Terminal saja saat boot |
| Shell | `bash` |
| Arsitektur | `x86_64` |
| Output | `out/puzzle-on-linux-<resep>-x86_64.iso` |
| Fitur | Bunglon 🦎, Play 🎮, Start Menu/Taskbar, Kernel Studio ⚙️, GUI Builder 🖥️, Pro Tools, Hacking & Coding |

## Fitur

- **Bunglon Core** — `run <app>` download + jalankan aplikasi desktop lewat `pacman`
- **Bunglon Play** — `play <game>` download + jalankan game
- **Start Menu** — `/menu/start` berisi semua fitur (mapping menu Windows)
- **Taskbar** — `/taskbar-all`, `go-to-taskbar/<app>`, `/uninstalled b- <app>`
- **Kernel Studio** — `kernel info/config/params/patch/sysctl/build/revert` dengan backup
- **Auto Setup** — hostname, locale Indonesia, timezone, DHCP, user, sudo, mirror otomatis
- **GUI Builder** — `gui build openbox|xfce` + `gui start`, boot tetap terminal
- **Pro Tools** — `puzzle status/doctor/snapshot/update/repo/splash`
- **Puzzle Info** — `puzzlefetch` (fastfetch + logo puzzle & kunci inggris), btop/htop
- **Hacking & Coding** — `hack ...` dan `code new/build/run`
- **Bisa dioprek** — `configs/airootfs/` bebas diedit

## Cara build ISO

ISO **tidak bisa dibuat di Windows**. Dua pilihan:

### A. GitHub Actions (paling gampang)
1. Push repo ini ke GitHub (branch `main`).
2. **Actions → Build Puzzle On Linux ISO → Run workflow** (resep: `bunglon`).
3. Download artifact `puzzle-on-linux-bunglon`.
4. File di dalamnya: `puzzle-on-linux-bunglon-x86_64.iso`.

### B. Arch Linux lokal
```bash
sudo pacman -S archiso git
git clone <repo> PuzzleOnLinux && cd PuzzleOnLinux
./puzzle build bunglon
```

## Pakai di VirtualBox

1. Buka VirtualBox → **New**.
2. Name: `Puzzle On Linux`, Type: **Linux**, Version: **Arch Linux (64-bit)**.
3. Memory: **2048 MB** (minimum 1024 MB).
4. Hard disk: **Create a virtual hard disk now** → VDI → ** dynamically allocated** → 20 GB.
5. Setelah VM dibuat: **Settings → Storage → Optical Drive → pilih ISO** yang di-download.
6. **Settings → System → Processor** → centang **Enable PAE/NX**, 2 CPU.
7. Klik **Start** → boot ke prompt `puzzle@piece:~$`.

Kalau mau coba tanpa VirtualBox:
```bash
qemu-system-x86_64 -m 2048 -cdrom out/puzzle-on-linux-bunglon-x86_64.iso -boot d
```

## Perintah setelah boot

```
/menu/start                  Start Menu
/taskbar-all                 taskbar
go-to-taskbar/firefox        pin aplikasi
run firefox                  jalankan aplikasi desktop
play supertux                jalankan game
kernel info                  akses kernel
puzzlefetch                  info sistem + logo puzzle & kunci inggris
bunglon task                 task manager (btop/htop)
gui build openbox            bangun GUI on-demand
puzzle doctor                cek kesehatan sistem
puzzle snapshot create       backup sebelum otak-atik
hack scan <host>             toolkit hacking
code new py hello            coding helper
```

## Dokumentasi

- [`docs/PIECES.md`](docs/PIECES.md) — format keping & daftar keping
- [`docs/BUILD.md`](docs/BUILD.md) — build, GitHub Actions, troubleshooting
- [`docs/BUNGLON.md`](docs/BUNGLON.md) — aplikasi, game, Start Menu, taskbar
- [`docs/KERNEL.md`](docs/KERNEL.md) — akses kernel
- [`docs/PRO.md`](docs/PRO.md) — GUI builder, pro tools
- [`docs/EXTRA.md`](docs/EXTRA.md) — fastfetch, task manager, hacking & coding

## Catatan

File lama `KatakFILES/...` sudah terhapus dari awal dan tidak disentuh. Belum ada commit.
