# Cara Build & Troubleshooting 🔧

## Kebutuhan

Jalankan di **Arch Linux**:

```bash
sudo pacman -S archiso git
```

> Proyek ini awalnya disusun di environment Windows, jadi script bash-nya
> belum dijalankan di sana. Build dilakukan di Arch/Linux.

## Alur build

```
puzzle build <resep>
  ├─ baca resep -> kumpulkan keping
  ├─ kumpulkan paket (dedupe)
  ├─ salin template archiso (baseline / releng)
  ├─ tulis profile/packages.x86_64
  ├─ salin configs/airootfs/  (UI & sistem yang bisa dioprek)
  ├─ salin aset tiap keping  (script Bunglon, kernel, database)
  ├─ tulis /etc/puzzle/pieces & os-release
  └─ mkarchiso -> out/puzzle-on-linux-<resep>-x86_64.iso
```

## Contoh

```bash
./puzzle list
./puzzle init racikanku
./puzzle add bunglon-core racikanku
./puzzle add bunglon-play racikanku
./puzzle add bunglon-menu racikanku
./puzzle add kernel-studio racikanku
./puzzle build racikanku
```

## Coba di VM

```bash
qemu-system-x86_64 -m 2048 -cdrom out/puzzle-on-linux-racikanku-x86_64.iso -boot d
```

Atau buat ISO baru di VirtualBox: *New machine → Attachment → pilih ISO*.

## Build otomatis via GitHub Actions

File `.github/workflows/build-iso.yml` menjalankan build di container
**Arch Linux** (Docker) pada runner GitHub:

1. Push repo ke GitHub (branch `main`/`master`).
2. Buka tab **Actions** → **Build Puzzle On Linux ISO** → **Run workflow**.
3. Isi resep (`bunglon`) → jalankan.
4. Download artifact `puzzle-on-linux-<resep>`.

Isi artifact: `puzzle-on-linux-<resep>-x86_64.iso`.

## Masalah umum

| Gejala | Solusi |
|---|---|
| `mkarchiso tidak ditemukan` | `sudo pacman -S archiso` |
| `Template archiso tidak ditemukan` | Path `/usr/share/archiso/configs/` kosong → reinstall `archiso` |
| Build gagal di `pacstrap`/`mkarchiso` | Jalankan dengan root atau pastikan user bisa `sudo` |
| ISO tidak boot di UEFI | Pastikan template memuat `bootmodes` EFI; coba template `releng` |
| Package tidak ditemukan | Nama paket salah / butuh multilib atau AUR → edit `apps.conf`/`games.conf` |
| VNC tidak bisa diakses | Cek `VNC_HOST` di `/etc/bunglon.conf` & firewall port 5900 |

## Mode tampilan Bunglon

Edit `/etc/bunglon.conf` di dalam ISO:

```bash
DISPLAY_MODE="vnc"    # headless, akses lewat vnc://IP:5900
# atau
DISPLAY_MODE="local"  # langsung startx + openbox di layar
```

## Oprek UI & sistem

Semua berkas di `configs/airootfs/` disalin apa adanya ke ISO. Contoh:

```bash
./puzzle ui root/.bashrc
./puzzle ui etc/motd
./puzzle ui etc/skel/.tmux.conf
```

Mau nambah file? Taruh saja di `configs/airootfs/path/tujuan`, lalu build ulang.
