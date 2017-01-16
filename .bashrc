#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias pacs='pacman -Ss'
alias pacq='pacman -Qs'
alias pacin='sudo pacman -S'
alias wifi='nmcli dev wifi'
alias lionmail='VMAIL_HOME=~/.vmail/Lionmail/ vmail'
alias gmail='VMAIL_HOME=~/.vmail/Gmail/ vmail'

# Start vim in servermode (needed for latexmk)
alias vim='vim --servername vim'
PS1='[\u@\h \W]\$ '

# Powerline
. /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
