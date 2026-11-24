# Puzzle On Linux — perakit ISO berbasis archiso.

collect_pieces() {
  local recipe="$1" p
  PUZZLE_PACKAGES=()
  PUZZLE_ASSETS=()
  PUZZLE_PIECE_IDS=()

  load_recipe "$recipe"
  for p in "${PIECES[@]}"; do
    load_piece "$p"
    PUZZLE_PIECE_IDS+=("$PIECE_NAME")
    PUZZLE_PACKAGES+=("${PIECE_PACKAGES[@]}")
    PUZZLE_ASSETS+=("${PIECE_ASSETS[@]}")
  done

  # Buang duplikat paket & aset, pertahankan urutan.
  local tmp
  # syslinux wajib ada di package list untuk boot mode BIOS pada profil archiso.
  PUZZLE_PACKAGES+=(syslinux)
  tmp="$(printf '%s\n' "${PUZZLE_PACKAGES[@]}" | dedupe_lines)"
  mapfile -t PUZZLE_PACKAGES <<< "$tmp"
  if [[ ${#PUZZLE_ASSETS[@]} -gt 0 ]]; then
    tmp="$(printf '%s\n' "${PUZZLE_ASSETS[@]}" | dedupe_lines)"
    mapfile -t PUZZLE_ASSETS <<< "$tmp"
  else
    PUZZLE_ASSETS=()
  fi
}

template_dir() {
  local d
  for d in \
    /usr/share/archiso/configs/baseline \
    /usr/share/archiso/configs/releng; do
    [[ -d "$d" ]] && { printf '%s' "$d"; return 0; }
  done
  return 1
}

cmd_build() {
  local recipe="${1:-minimal}"
  load_recipe "$recipe"
  collect_pieces "$recipe"
  require_cmd mkarchiso

  local template
  template="$(template_dir)" || die "Template archiso tidak ditemukan. Install: sudo pacman -S archiso"

  local work="$PUZZLE_ROOT/work/$recipe-profile"
  local out="$PUZZLE_ROOT/out"
  local profile="$work/profile"
  local airootfs="$profile/airootfs"
  local asset src dst

  info "Resep      : $recipe"
  info "Keping     : ${PUZZLE_PIECE_IDS[*]}"
  info "Paket      : ${#PUZZLE_PACKAGES[@]} item"
  info "Template   : $template"

  rm -rf "$work"
  mkdir -p "$work" "$out"
  cp -a "$template" "$profile"

  # Daftar paket hasil racikan keping.
  printf '%s\n' "${PUZZLE_PACKAGES[@]}" > "$profile/packages.x86_64"

  # Overlay UI/sistem: semua berkas di configs/airootfs ikut ke ISO.
  if [[ -d "$PUZZLE_ROOT/configs/airootfs" ]]; then
    cp -a "$PUZZLE_ROOT/configs/airootfs/." "$airootfs/"
  fi

  # Aset dari keping (misal script Bunglon & database aplikasinya).
  for asset in "${PUZZLE_ASSETS[@]}"; do
    [[ -n "$asset" ]] || continue
    src="$PUZZLE_ROOT/assets/$asset"
    dst="$airootfs/$asset"
    [[ -f "$src" ]] || die "Aset keping tidak ditemukan: $src"
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
    chmod 755 "$dst"
  done

  # Identitas sistem & daftar keping di dalam ISO.
  mkdir -p "$airootfs/etc/puzzle"
  printf '%s\n' "${PUZZLE_PIECE_IDS[@]}" > "$airootfs/etc/puzzle/pieces"
  printf 'Puzzle On Linux %s — resep: %s\n' "$PUZZLE_VERSION" "$recipe" > "$airootfs/etc/puzzle/version"

  cat > "$airootfs/etc/os-release" <<EOF
NAME="Puzzle On Linux"
PRETTY_NAME="Puzzle On Linux ($recipe)"
ID=puzzle
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://github.com/"
LOGO=puzzle
EOF

  # Nama file ISO (archiso versi baru memakai profiledef.sh).
  if [[ -f "$profile/profiledef.sh" ]]; then
    sed -i \
      -e "s|^iso_name=.*|iso_name=\"puzzle-on-linux-$recipe\"|" \
      -e "s|^iso_version=.*|iso_version=\"$PUZZLE_VERSION\"|" \
      -e 's|^iso_publisher=.*|iso_publisher="Puzzle On Linux"|' \
      -e 's|^iso_application=.*|iso_application="Puzzle On Linux (terminal-only)"|' \
      -e 's|^install_dir=.*|install_dir="puzzle"|' \
      "$profile/profiledef.sh"
  fi

  info "Merakit ISO... (ini bisa beberapa menit)"
  mkarchiso -v -w "$work" -o "$out" "$profile"

  local target="$out/puzzle-on-linux-$recipe-x86_64.iso"
  local built
  built="$(find "$out" -maxdepth 1 -type f -name '*.iso' -printf '%T@ %p\n' 2>/dev/null \
           | sort -rn | head -n1 | cut -d' ' -f2-)"
  if [[ -n "$built" && "$built" != "$target" ]]; then
    mv -f "$built" "$target"
  fi

  ok "Selesai: $target"
  info "Coba di VM: qemu-system-x86_64 -m 1024 -cdrom '$target' -boot d"
}

cmd_clean() {
  rm -rf "$PUZZLE_ROOT/work"
  ok "Workspace build dibersihkan."
}
