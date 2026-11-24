# Jalankan puzzle-firstboot sekali saat login pertama.
if [[ $- == *i* && -x /usr/local/bin/puzzle-firstboot && ! -f /etc/puzzle/.firstboot-done ]]; then
  /usr/local/bin/puzzle-firstboot
fi
