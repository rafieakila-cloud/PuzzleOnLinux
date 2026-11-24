# Kernel Studio ⚙️ — Akses Kernel dari Prompt

Keping `kernel-studio` memasang perintah `kernel` di dalam ISO.
Semua perubahan **di-backup otomatis** ke `~/.config/puzzle/kernel/`.

## Perintah

```bash
kernel info                   versi kernel, cmdline, jumlah modul
kernel modules                daftar modul aktif
kernel module-load <nama>     muat modul
kernel module-unload <nama>   bongkar modul
kernel params                 lihat/edit parameter boot (cmdline)
kernel config                 ambil .config lalu edit pakai $EDITOR
kernel patch <file.patch>     apply patch ke source kernel
kernel sysctl                 edit /etc/sysctl.d/99-puzzle.conf
kernel build                  build + install kernel hasil editan
kernel revert                 kembalikan dari backup
```

## Alur otak-atik yang aman

```bash
kernel info                 # lihat dulu kondisi kernel
kernel config               # ambil .config, edit sesuai selera
kernel params               # misal tambah quiet / mitigasi / dll
kernel sysctl               # tuning jaringan/vm di runtime
kernel build                # build & install (konfirmasi YA)
kernel revert               # kalau hasilnya bikin boot gagal
```

## Sumber kernel

`KDIR` diodeksi otomatis:

1. `/usr/lib/modules/$(uname -r)/build` (dari paket `linux-headers`)
2. `/usr/src/linux` (fallback)

## Parameter boot

- Kalau ada `/etc/default/grub` → edit `GRUB_CMDLINE_LINUX_DEFAULT`, lalu `grub-mkconfig`.
- Kalau pakai systemd-boot → edit `/boot/loader/entries/*.conf`, lalu `bootctl update`.

## Peringatan ⚠️

`kernel build` **mengganti kernel yang dipakai**. Sebelum mencoba:

- Simpan ISO install (live USB).
- Pastikan backup di `~/.config/puzzle/kernel/` masih ada.
- Kalau boot gagal, boot ISO → `kernel revert` → reboot.

## Keping terkait

```bash
./puzzle add kernel-studio racikanku
./puzzle build racikanku
```
