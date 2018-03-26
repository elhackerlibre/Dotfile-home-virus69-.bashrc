#!/bin/bash

## ~/.bashrc
##
## User:        Felix Molero
## E-mail:      fmolero69@gmail.com
## License:     GPL v3+
## Copyright (C) 2018-03-24 15:12

echo $(clear)
reset=$(tput sgr0)
bold=$(tput bold)

export LC_ALL=es_VE.UTF-8
#=============================================================================#

# Scripts color scheme

echo -e '\n\e[01;30m ▚ \e[0;30m ▞ \e[01;31m ▚ \e[0;31m ▞ \e[01;32m ▚ \e[0;32m ▞ \e[01;33m ▚ \e[0;33m ▞ \e[01;34m ▚ \e[0;34m ▞ \e[01;35m ▚ \e[0;35m ▞ \e[01;36m ▚ \e[0;36m ▞ \e[01;37m ▚ \e[0;37m ▞'

#=============================================================================#

[ -z "$PS1" ]&& return

export HISTCONTROL=ignoredups
export IGNOREEOF=100

# Ajustar tamaño de la ventana
shopt -s checkwinsize

#=================================== Prompt ==================================#

case "$TERM" in
	xterm-color)
		PS1="\n\[\e[0;31m\]┌─[\[\e[0;36m\u\e[0;31m\]]──[\e[1;37m\w\e[0;31m]──[\[\e[0;36m\]${HOSTNAME%%.*}\[\e[0;31m\]]\[\e[1;35m\]:\$\[\e[0;31m\]\n\[\e[0;31m\]└────╼ \[\e[1;35m\]>> \[\e[00;00m\]"
		;;
	*)
		PS1="\n\[\e[1;30m\]┌─[\[\e[0;36m\u\e[1;30m\]]──[\e[1;31m\w\e[1;30m]──[\[\e[0;36m\]${HOSTNAME%%.*}\[\e[1;30m\]]\[\e[1;35m\]:\#\[\e[1;30m\]\n\[\e[1;30m\]└────╼ \[\e[0;36m\]>> \[\e[00;00m\]"
		;;
esac

#============================= Comandos útiles ===============================#

# Visualizar ficheros y directorios
function cdls { cd "$1"; ls --color; }
alias cd='cdls'

export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'

# Completación de búsqueda
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#============================== Funciones ====================================#

# Descomprimir paquetes
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1;;
             *.tar.gz)    tar xzf $1;;
             *.bz2)       bunzip2 $1;;
             *.rar)       rar x $1;;
             *.gz)        gunzip $1;;
             *.tar)       tar xf $1;;
             *.tbz2)      tar xjf $1;;
             *.tgz)       tar xzf $1;;
             *.zip)       unzip $1;;
             *.Z)         uncompress $1;;
             *.7z)        7z x $1;;
             *)           echo "'$1' No se puede extraer mediante extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# nota simple
nota () {
    # if file doesn't exist, create it
    if [[ ! -f $HOME/notas ]]; then
        touch "$HOME/notas"
    fi

    if ! (($#)); then
        # no arguments, print file
        cat "$HOME/notas"
    elif [[ "$1" == "-c" ]]; then
        # clear file
        printf "%s" > "$HOME/notas"
    else
        # add all arguments to file
        printf "%s\n" "$*" >> "$HOME/notas"
    fi
}

# Utilidad de tarea simple
todo() {
    if [[ ! -f $HOME/todo ]]; then
        touch "$HOME/todo"
    fi

    if ! (($#)); then
        cat "$HOME/todo"
    elif [[ "$1" == "-l" ]]; then
        nl -b a "$HOME/todo"
    elif [[ "$1" == "-c" ]]; then
        > $HOME/todo
    elif [[ "$1" == "-r" ]]; then
        nl -b a "$HOME/todo"
        eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}; echo
        read -p "Type a number to remove: " number
        sed -i ${number}d $HOME/todo "$HOME/todo"
    else
        printf "%s\n" "$*" >> "$HOME/todo"
    fi
}

# calculadora
calc() {
    echo "scale=3;$@" | bc -l
}

# IP info
ipif() {
    if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
	curl ipinfo.io/"$1"
    else
	ipawk=($(host "$1" | awk '/address/ { print $NF }'))
	curl ipinfo.io/${ipawk[1]}
    fi
    echo
}

espacio () {
    echo $(clear)
    du -lsh /var/cache/pacman/pkg
}

limpiar () {
    echo $(clear)
    echo "Limpiando paquetes cache..."
    sudo paccache -rk1 &&
    echo ""
    echo "Limpiando paquetes huérfanos..."
    sudo pacman -Rs $(pacman -Qtdq) &&
    echo $(clear)
}

#================================== Alias ====================================#
alias actualizar='echo $(clear);sudo pacman -Syyu --noconfirm'
alias linksrotos='sudo find -xtype l -print'
alias musica='ncmpcpp -S visualizer'
alias normailizar='mp3gain -r *.mp3'
alias registro='journalctl -p 3 -xb'
alias servifail='systemctl --failed'
alias sincronizar='ping -c 8.8.8.8'
alias terminal='xrdb ~/.Xresources'
alias red='sudo systemctl restart NetworkManager.service'

#=============================================================================#
#	Colors:

#  BLACK=	'\e[0;30m'
#  RED=		'\e[0;31m'
#  GREEN=	'\e[0;32m'
#  YELLOW=	'\e[0;33m'
#  BLUE=	'\e[0;34m'
#  MAGENT=	'\e[0;35m'
#  CYAN=	'\e[0;36m'
#  WHITE=	'\e[0;37m'

#  LIGHTBLACK=	'\e[1;30m'
#  LIGHTRED=	'\e[1;31m'
#  LIGHTGREEN=	'\e[1;32m'
#  LIGHTYELLOW=	'\e[1;33m'
#  LIGHTBLUE=	'\e[1;34m'
#  LIGHTMAGENT= '\e[1;35m'
#  LIGHTCYAN=	'\e[1;36m'
#  LIGHTWHITE=	'\e[1;37m'

