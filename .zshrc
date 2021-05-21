if [[ -x "$(which tmux)" ]]; then
    if [[ -z ${TMUX} ]]; then # if no session is started, start a new session
      tmux attach 2> /dev/null || tmux
    fi
fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Make sure you have gawk installed otherwise zplug install will fail
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Node Version manager for managing node versions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# TODO: Find a more reliable way of dealing with SSH agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

#SSH Reagent (http://tychoish.com/post/9-awesome-ssh-tricks/)
ssh-reagent () {
  for agent in /tmp/ssh-*/agent.*; do
      export SSH_AUTH_SOCK=$agent
      if ssh-add -l 2>&1 > /dev/null; then
         echo Found working SSH Agent:
         ssh-add -l
         return
      fi
  done
  echo Cannot find ssh agent - maybe you should reconnect and forward it?
}

#if you do a 'rm *', Zsh will give you a sanity check!
setopt RM_STAR_WAIT

# Zsh has a spelling corrector
setopt CORRECT

# Set our username so the prompt hides it
export DEFAULT_USER=`whoami`

# Set go variables
export GOPATH=$HOME/.local/go

#Set XDG Base directory specificatins
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa

# Add local bin directories to PATH
export PATH="$PATH:$HOME/.local/bin:$HOME/.composer/vendor/bin:$HOME/.local/go/bin"

# Make VIM the default editor
export EDITOR=vim

# Use Docker BuildKit
export DOCKER_BUILDKIT=1

# This messes up highlight
# zstyle :incremental list yes
# autoload -U incremental-complete-word
# zle -N incremental-complete-word
# bindkey '^X' incremental-complete-word

# Essential for zplug
source ~/.zplug/init.zsh

##################################zsh plugins######################################

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# Make sure to use double quotes to prevent shell expansioni
zplug "romkatv/powerlevel10k", as:theme, depth:1

# Use oh my zsh defaults because we <3 it!
for LIB in compfix completion correction diagnostics directories functions git grep history key-bindings misc nvm prompt_info_functions spectrum termsupport theme-and-appearance ssh-agent kubectl
do
    zplug "lib/${LIB}", from:oh-my-zsh, depth:1
done;

zplug "plugins/fancy-ctrl-z", from:oh-my-zsh, depth:1

zplug 'junegunn/fzf', depth:1, hook-build:'./install --key-bindings --completion --no-update-rc --no-fish'
zplug "zuxfoucault/colored-man-pages_mod", depth:1
# zplug "arzzen/calc.plugin.zsh"
# Fish shell like autosuggestions
zplug "zsh-users/zsh-autosuggestions", depth:1
zplug "zsh-users/zsh-syntax-highlighting", depth:1

##################################plugins for others######################################

zplug "tmux-plugins/tpm", depth:1

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

# Because fzf likes to make a file in the home directory, enable it manually here
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#Enable Asynchronous Mode for suggestions
ZSH_AUSOSUGGEST_USE_ASYNC=true

# Override oh-my-zsh history size
HISTSIZE=100000
SAVEHIST=100000

# Stop using pushd like a crazy person
unsetopt auto_pushd

# Only enable this once you have zsh 5.7 or greater
[[ "$COLORTERM" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor

##################################Windows (is special) quircks######################################

export DISPLAY=$(/mnt/c/Windows/System32/ipconfig.exe | grep -A 5 "vEthernet (WSL)" | grep -oP '(?<=IPv4 Address(?:\.\s){11}:\s)((?:\d+\.){3}\d+)'):0.0
export LIBGL_ALWAYS_INDIRECT=1

##################################Aliases######################################
#
# Color ls
if [ -x "$(which lsd)" ]; then
    alias ls='lsd'
fi

if [ -x "$(which xclip)" ]; then
    #Copy to clipboard
    alias xc="xclip -selection c"

    #Paste from clipboard
    alias xp="xclip -selection clipboard -o"
elif [ -x "$(which termux-clipboard-get)" ]; then 
    alias xc="termux-clipboard-get"
    alias xp="termux-clipboard-set"
fi

alias glances="glances 2> /dev/null"
setopt monitor

# Don't make using bash interactively impossible
alias bash="PERMIT_BASH=true bash"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
