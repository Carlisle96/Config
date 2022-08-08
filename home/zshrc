# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/thyriaen/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

ZSH_THEME="powerlevel10k/powerlevel10k"
source ~/.term/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

source ~/.term/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/doc/fzf/examples/key-bindings.zsh
