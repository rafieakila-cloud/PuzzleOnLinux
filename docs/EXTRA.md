# Puzzle Info, Task Manager, Hacking & Coding 🧩

## Puzzle Info — fastfetch

Keping `puzzle-info` memasang `fastfetch`, `btop`, `htop`, plus:

- `/etc/fastfetch/puzzle-logo.txt` — logo puzzle + kunci inggris
- `/etc/fastfetch/puzzle.conf` — konfigurasi memakai logo itu
- `/usr/local/bin/puzzlefetch` (alias `pf`)

```bash
puzzlefetch
```

Edit logo: `assets/etc/fastfetch/puzzle-logo.txt` lalu build ulang.

## Task Manager bawaan

```bash
bunglon task     # btop -> htop -> top
btop
htop
```

Juga tersedia di `/menu/start`.

## Hacking Toolkit

```bash
hack scan <host>       # nmap -sV -T4
hack ports <host>      # nmap -p-
hack sniff [iface]     # tshark
hack wifi              # iw + aircrack-ng
hack hash <file>       # john
hack dns <domain>      # dig
```

⚠️ Pakai hanya pada target yang kamu kuasai / ada izinnya.

## Coding Helper

```bash
code new py hello      # hello.py
code new c main
code new go main
code run hello.py
code build main.c
```

Template menyapa: `Hello Puzzle On Linux!`.

## Masuk ke ISO

```bash
./puzzle build bunglon
```

Atau manual:

```bash
./puzzle add puzzle-info racikanku
./puzzle add hacking-coding racikanku
./puzzle build racikanku
```
