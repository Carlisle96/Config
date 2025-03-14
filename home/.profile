# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ls='ls --color=auto'
alias ll='ls -al'
alias la='ls -A'
alias l='ls -C'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias nnn='nnn -d -P p'

PATH=$PATH:~/.local/bin

export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui;d:drag;o:xdgdefault'
export NNN_BATTHEME='Monokai Extended'

export TERMINAL=kitty
export SHELL=/usr/bin/zsh

export EDITOR=vi
export VISUAL=vi

export GTK_USE_PORTAL=1
export XDG_CURRENT_DESKTOP=xmonad
export XDG_CONFIG_HOME=$HOME/.config