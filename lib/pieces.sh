# Puzzle On Linux — katalog keping & manajemen resep.

reset_piece() {
  PIECE_NAME=''
  PIECE_TITLE=''
  PIECE_DESC=''
  PIECE_REQUIRED=0
  PIECE_PACKAGES=()
  PIECE_SERVICES=()
  PIECE_ASSETS=()
  PIECE_NOTES=''
}

piece_path() {
  local id="$1" f
  f="$PUZZLE_ROOT/pieces/$id.piece"
  if [[ -f "$f" ]]; then
    printf '%s' "$f"
    return 0
  fi
  # File keping boleh diawali nomor urut, mis. 00-base.piece untuk id 'base'.
  for f in "$PUZZLE_ROOT"/pieces/*-"$id".piece; do
    if [[ -f "$f" ]]; then
      printf '%s' "$f"
      return 0
    fi
  done
  printf '%s' "$f"
}

recipe_path() {
  printf '%s/recipes/%s.recipe' "$PUZZLE_ROOT" "$1"
}

piece_exists() {
  [[ -f "$(piece_path "$1")" ]]
}

recipe_exists() {
  [[ -f "$(recipe_path "$1")" ]]
}

load_piece() {
  local id="$1" file
  file="$(piece_path "$id")"
  [[ -f "$file" ]] || die "Keping '$id' tidak ditemukan. Coba: ./puzzle list"
  reset_piece
  # shellcheck disable=SC1090
  source "$file"
  [[ -n "$PIECE_NAME" ]] || die "Keping '$id' tidak punya PIECE_NAME."
  PIECE_NAME="${PIECE_NAME:-$id}"
}

load_recipe() {
  local name="$1" file
  file="$(recipe_path "$name")"
  [[ -f "$file" ]] || die "Resep '$name' tidak ditemukan. Coba: ./puzzle init $name"
  RECIPE_NAME=''
  RECIPE_DESC=''
  PIECES=()
  # shellcheck disable=SC1090
  source "$file"
  [[ -n "$RECIPE_NAME" ]] || die "Resep '$name' tidak punya RECIPE_NAME."
  [[ ${#PIECES[@]} -gt 0 ]] || die "Resep '$name' belum punya keping. Tambah dengan: ./puzzle add <keping> $name"
}

cmd_list() {
  printf '%sKatalog kepingan:%s\n' "$C_BOLD" "$C_RESET"
  local f name desc req
  for f in "$PUZZLE_ROOT"/pieces/*.piece; do
    [[ -e "$f" ]] || continue
    reset_piece
    # shellcheck disable=SC1090
    source "$f"
    req=''
    [[ "$PIECE_REQUIRED" == "1" ]] && req=" ${C_YELLOW}(wajib)${C_RESET}"
    printf '  %-14s %s%s\n' "$PIECE_NAME" "$PIECE_DESC" "$req"
  done

  printf '\n%sResep (contoh, bebas diubah):%s\n' "$C_BOLD" "$C_RESET"
  for f in "$PUZZLE_ROOT"/recipes/*.recipe; do
    [[ -e "$f" ]] || continue
    RECIPE_NAME='' RECIPE_DESC='' PIECES=()
    # shellcheck disable=SC1090
    source "$f"
    printf '  %-14s %s\n' "$RECIPE_NAME" "$RECIPE_DESC"
    printf '  %-14s %s keping: %s\n' '' "$C_DIM" "${PIECES[*]}${C_RESET}"
  done

  printf '\n%sUI / sistem yang bisa dioprek:%s %s\n' "$C_BOLD" "$C_RESET" "$PUZZLE_ROOT/configs/airootfs"
  printf '  Lihat: %s\n' "${C_CYAN}./puzzle ui${C_RESET}"
}

cmd_show() {
  local id="${1:-}"
  [[ -n "$id" ]] || die "Usage: ./puzzle show <keping>"
  load_piece "$id"
  printf '\n%s%s%s — %s\n' "$C_BOLD" "$PIECE_NAME" "$C_RESET" "$PIECE_TITLE"
  printf '%s\n' "$PIECE_DESC"
  printf '\n%sPaket Arch:%s\n' "$C_BOLD" "$C_RESET"
  if [[ ${#PIECE_PACKAGES[@]} -eq 0 ]]; then
    printf '  %s(tanpa paket — hanya konfigurasi)%s\n' "$C_DIM" "$C_RESET"
  else
    printf '  %s\n' "${PIECE_PACKAGES[@]}"
  fi
  if [[ ${#PIECE_SERVICES[@]} -gt 0 ]]; then
    printf '\n%sService:%s\n' "$C_BOLD" "$C_RESET"
    printf '  %s\n' "${PIECE_SERVICES[@]}"
  fi
  if [[ ${#PIECE_ASSETS[@]} -gt 0 ]]; then
    printf '\n%sBerkas masuk ISO:%s\n' "$C_BOLD" "$C_RESET"
    printf '  %s\n' "${PIECE_ASSETS[@]}"
  fi
  if [[ -n "$PIECE_NOTES" ]]; then
    printf '\n%sCatatan:%s %s\n' "$C_BOLD" "$C_RESET" "$PIECE_NOTES"
  fi
  printf '\n%sFile: %s\n' "$C_DIM" "$(piece_path "$id")${C_RESET}"
}

cmd_init() {
  local name="${1:-}"
  [[ -n "$name" ]] || die "Usage: ./puzzle init <nama-resep>"
  [[ "$name" =~ ^[a-z0-9_-]+$ ]] || die "Nama resep hanya boleh huruf kecil, angka, '-' dan '_'."
  recipe_exists "$name" && die "Resep '$name' sudah ada."

  local dst
  dst="$(recipe_path "$name")"
  cp "$PUZZLE_ROOT/recipes/minimal.recipe" "$dst"
  sed -i "s|^RECIPE_NAME=.*|RECIPE_NAME=\"$name\"|" "$dst"
  sed -i "s|^RECIPE_DESC=.*|RECIPE_DESC=\"Resep racikan $name (berbasis minimal)\"|" "$dst"
  ok "Resep baru dibuat: recipes/$name.recipe"
  info "Tambah keping: ./puzzle add <keping> $name"
  info "Lalu rakit:     ./puzzle build $name"
}

# Cari keping; kalau tidak ada, buatkan keping otomatis dari paket Arch.
ensure_piece() {
  local id="$1" slug file

  if piece_exists "$id"; then
    return 0
  fi

  slug="$(slugify "$id")"
  [[ -n "$slug" ]] || die "Nama keping '$id' tidak valid."
  if piece_exists "$slug"; then
    return 0
  fi

  file="$(piece_path "$slug")"
  cat > "$file" <<EOF
# Keping otomatis — dibuat oleh 'puzzle add $id'.
# Bebas diedit: tambah paket, service, atau catatan sesuai kebutuhan.
PIECE_NAME="$slug"
PIECE_TITLE="Keping otomatis: $id"
PIECE_DESC="Paket Arch '$id' (dibuat otomatis)"
PIECE_REQUIRED=0
PIECE_PACKAGES=("$id")
PIECE_SERVICES=()
PIECE_NOTES="Keping generatif. Edit file ini kalau butuh paket tambahan."
EOF
  warn "Keping otomatis dibuat: pieces/$slug.piece"
  printf '%s' "$slug"
}

recipe_write_pieces() {
  local file="$1"; shift
  local line='' p tmp
  for p in "$@"; do
    line+=" \"$p\""
  done
  line="PIECES=($line )"
  tmp="${file}.tmp"
  awk -v new="$line" '/^PIECES=/{print new; next} {print}' "$file" > "$tmp"
  mv "$tmp" "$file"
}

cmd_add() {
  local id="${1:-}" name="${2:-minimal}"
  [[ -n "$id" ]] || die "Usage: ./puzzle add <keping> [resep]"

  local resolved
  resolved="$(ensure_piece "$id")"
  resolved="${resolved:-$id}"

  load_recipe "$name"
  local p found=0 out=()
  for p in "${PIECES[@]}"; do
    if [[ "$p" == "$resolved" ]]; then found=1; fi
    out+=("$p")
  done
  if [[ $found -eq 1 ]]; then
    warn "Keping '$resolved' sudah ada di resep '$name'."
    return 0
  fi
  out+=("$resolved")
  recipe_write_pieces "$(recipe_path "$name")" "${out[@]}"
  ok "Keping '$resolved' ditambahkan ke resep '$name'."
}

cmd_remove() {
  local id="${1:-}" name="${2:-minimal}"
  [[ -n "$id" ]] || die "Usage: ./puzzle remove <keping> [resep]"
  load_recipe "$name"

  local resolved="$id"
  if ! piece_exists "$id"; then
    resolved="$(slugify "$id")"
  fi
  [[ "$resolved" != "base" ]] || die "Keping 'base' wajib dan tidak bisa dibuang."

  local p out=() found=0
  for p in "${PIECES[@]}"; do
    if [[ "$p" == "$resolved" ]]; then
      found=1
      continue
    fi
    out+=("$p")
  done
  [[ $found -eq 1 ]] || die "Keping '$resolved' tidak ada di resep '$name'."
  ((${#out[@]} > 0)) || die "Resep tidak boleh kosong."
  recipe_write_pieces "$(recipe_path "$name")" "${out[@]}"
  ok "Keping '$resolved' dibuang dari resep '$name'."
}

cmd_ui() {
  local overlay="$PUZZLE_ROOT/configs/airootfs"
  local target="${1:-}"
  if [[ -z "$target" ]]; then
    printf '%sBerkas/system & UI yang bisa dioprek:%s\n' "$C_BOLD" "$C_RESET"
    printf '  %s\n' "$overlay"
    printf '\n'
    (cd "$overlay" && find . -type f | sort) | while read -r f; do
      printf '  %s\n' "${f#./}"
    done
    printf '\n%sEdit salah satu:%s %s\n' "$C_BOLD" "$C_RESET" "${C_CYAN}./puzzle ui etc/motd${C_RESET}"
    printf '%sTambah berkas apa pun di folder itu — semuanya ikut ke ISO.%s\n' "$C_DIM" "$C_RESET"
    return 0
  fi
  local file="$overlay/$target"
  [[ -f "$file" ]] || die "Berkas '$target' tidak ada. Lihat daftar: ./puzzle ui"
  "${EDITOR:-vi}" "$file"
}
