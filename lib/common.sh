# Puzzle On Linux — helper umum.
# Dimuat oleh ./puzzle, jangan dijalankan langsung.

PUZZLE_VERSION="0.1.0"

if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_GREEN=$'\033[32m'
  C_CYAN=$'\033[36m'
  C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'
  C_BLUE=$'\033[34m'
  C_DIM=$'\033[2m'
else
  C_RESET='' C_BOLD='' C_GREEN='' C_CYAN='' C_YELLOW='' C_RED='' C_BLUE='' C_DIM=''
fi

info() { printf '%s[*]%s %s\n' "$C_CYAN" "$C_RESET" "$*"; }
ok()   { printf '%s[✓]%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf '%s[!]%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
die()  { printf '%s[x]%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Butuh perintah '$1' terinstall di sistem kamu."
}

# Hilangkan duplikat baris tapi tetap urut.
dedupe_lines() {
  awk '!seen[$0]++'
}

slugify() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g'
}
