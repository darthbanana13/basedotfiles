# .zshrc

# If not chsh to zsh make sure the SHELL value is sane
export SHELL="$(which zsh)"

# Set XDG Base directory specificatins
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

cmdExists() {
  [[ -z "$1" ]] && echo "No argument supplied" && exit 1
  command -v $1 &> /dev/null
}

# In case this fails: https://stackoverflow.com/a/48877084
# sudo ln -sf /usr/share/terminfo/x/xterm-color /usr/share/terminfo/x/xterm-256color
# or follow the terminfo steps for alacritty
if cmdExists tmux && [[ -z "${TMUX}" ]]; then
   tmux attach 2> /dev/null || tmux
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
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
export DEFAULT_USER="$(whoami)"

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa

# Add local bin directories to PATH
export PATH="${PATH}:${HOME}/.local/bin"

if [[ -d "${HOME}/.composer/vendor/bin" ]]; then
  export PATH="${PATH}:${HOME}/.composer/vendor/bin"
fi
if [[ -d "${HOME}/.local/go/bin" ]]; then
  export PATH="${PATH}:${HOME}/.local/go/bin"
  export GOPATH="${HOME}/.local/go"
fi
if [[ -d "/usr/lib/jvm/java-16-openjdk-amd64" ]]; then
  export JAVA_HOME="/usr/lib/jvm/java-16-openjdk-amd64"
fi
if [[ -d "${HOME}/.poetry/bin" ]]; then
  export PATH="${HOME}/.poetry/bin:$PATH"
fi

# Make VIM the default editor
export EDITOR=vim

# Use Docker BuildKit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Always opt out of the .NET telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# This messes up highlight
# zstyle :incremental list yes
# autoload -U incremental-complete-word
# zle -N incremental-complete-word
# bindkey '^X' incremental-complete-word

# Essential for zplug
source ~/.zplug/init.zsh

##################################zsh plugins######################################

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "direnv/direnv", as:command, rename-to:direnv, use:"direnv", hook-build:"make"
if cmdExists direnv; then
  # supress DIRENV messages for instant prompt, comment the line below for debugging DIRENV
  export DIRENV_LOG_FORMAT=
  eval "$(direnv hook zsh)"
fi

# Use oh my zsh defaults because we <3 it!
for LIB in compfix completion correction diagnostics directories functions git grep history key-bindings misc nvm prompt_info_functions spectrum termsupport theme-and-appearance ssh-agent kubectl direnv
do
  zplug "lib/${LIB}", from:oh-my-zsh, depth:1
done;

zplug "plugins/fancy-ctrl-z", from:oh-my-zsh, depth:1

zplug 'junegunn/fzf', depth:1, hook-build:'./install --key-bindings --completion --no-update-rc --no-fish'
zplug "zuxfoucault/colored-man-pages_mod", depth:1

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
  fi
fi

zplug load

# Because fzf likes to make a file in the home directory, enable it manually here
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh

  if cmdExists fd; then
    _fzf_compgen_path() {
      fd --color=always --follow --hidden --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
      fd --type d --color=always --follow --hidden --exclude ".git" . "$1"
    }

    export FZF_DEFAULT_COMMAND="fd --type file --color=always --follow --hidden --exclude .git"
    export FZF_DEFAULT_OPTS="--ansi"
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
    export FZF_TMUX_OPTS="-p 95%,60%"
  fi
fi

#Enable Asynchronous Mode for suggestions
export ZSH_AUSOSUGGEST_USE_ASYNC=true

# Override oh-my-zsh history size
export HISTSIZE=100000
export SAVEHIST=${HISTSIZE}
setopt EXTENDED_HISTORY

# Stop using pushd like a crazy person
unsetopt auto_pushd

# Only enable this once you have zsh 5.7 or greater
[[ "$COLORTERM" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor

##################################Load custom files######################################
for file in vars aliases func; do
  [[ ! -f "${HOME}/.shell/${file}.sh" ]] || source "${HOME}/.shell/${file}.sh"
done

##################################Windows (is special) quirks######################################
if [[ -d "/mnt/c/Windows" ]]; then
  setDisplay
  export LIBGL_ALWAYS_INDIRECT=1
  
  # Start Docker daemon automatically when logging in
  # RUNNING=`ps aux | grep dockerd | grep -v grep`
  # if [ -z "$RUNNING" ]; then
    # sudo dockerd > /dev/null 2>&1 &
    # disown
  # fi
fi

##################################Aliases######################################

# Color ls
cmdExists lsd && alias ls='lsd'

if cmdExists xclip; then
  #Copy to clipboard
  alias xc="xclip -selection c"

  #Paste from clipboard
  alias xp="xclip -selection clipboard -o"
elif cmdExists termux-clipboard-get; then 
  alias xc="termux-clipboard-get"
  alias xp="termux-clipboard-set"
fi

alias glances="glances 2> /dev/null"
setopt monitor

# Don't make using bash interactively impossible
alias bash="PERMIT_BASH=true bash"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
