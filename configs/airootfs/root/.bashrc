# Puzzle prompt — dioprek bebas: ./puzzle ui root/.bashrc
[[ $- != *i* ]] && return

PS1='\[\e[1;32m\]puzzle\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\]:\[\e[1;36m\]\w\[\e[0m\]\$ '
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias b='bunglon'
alias k='kernel'
alias pf='puzzlefetch'

# Tangkap perintah khas Puzzle (/menu/start, /taskbar-all, go-to-taskbar/...)
[[ -r /etc/profile.d/bunglon.sh ]] && source /etc/profile.d/bunglon.sh

printf '\n'
