# Puzzle prompt — template untuk user baru.
[[ $- != *i* ]] && return

PS1='\[\e[1;32m\]puzzle\[\e[0m\]@\[\e[1;34m\]\u\[\e[0m\]:\[\e[1;36m\]\w\[\e[0m\]\$ '
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias ..='cd ..'
alias b='bunglon'
alias k='kernel'
alias pf='puzzlefetch'

[[ -r /etc/profile.d/bunglon.sh ]] && source /etc/profile.d/bunglon.sh
