# Tangkap perintah khas Puzzle yang mengandung '/' atau nama khusus.
# Dimuat dari /etc/profile saat login; ./puzzle juga menyalin ini ke ~/.bashrc.

command_not_found_handle() {
  local first="${1-}"

  if command -v bunglon >/dev/null 2>&1; then
    case "$first" in
      /taskbar-all|/menu/*|/uninstalled|go-to-taskbar/*)
        bunglon dispatch "$@"
        return $?
        ;;
    esac
  fi

  # Fallback ke helper Arch kalau tersedia.
  if [[ -x /usr/bin/command-not-found ]]; then
    /usr/bin/command-not-found "$@"
    return $?
  fi

  printf 'puzzle: perintah tidak ditemukan: %s\n' "$first" >&2
  return 127
}
