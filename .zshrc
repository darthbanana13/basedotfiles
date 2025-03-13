# .zshrc

# If not chsh to zsh make sure the SHELL value is sane
export SHELL="$(which zsh)"

# Set XDG Base directory specificatins
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# XDG_RUNTIME_DIR should generally default to
[[ -z "${XDG_RUNTIME_DIR}" ]] && export XDG_RUNTIME_DIR="/run/user/$(id -u)/"

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

# Node Version manager for managing node versions
if [[ -d "${HOME}/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

#if you do a 'rm *', Zsh will give you a sanity check!
setopt RM_STAR_WAIT

# Zsh has a spelling corrector
setopt CORRECT

# Make sure job control is enabled (default yes for interactive shells)
setopt monitor

# Set our username so the prompt hides it
export DEFAULT_USER="$(whoami)"

# Set ssh-agent params
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent lifetime 1h
zstyle :omz:plugins:ssh-agent quiet yes # for Powerlevel10k instant prompt
zstyle :omz:plugins:ssh-agent lazy yes # prompt & load after first use of the key

# Add local bin directories to PATH
export PATH="${PATH}:${HOME}/.local/bin"

if [[ -d "${HOME}/.composer/vendor/bin" ]]; then
  export PATH="${PATH}:${HOME}/.composer/vendor/bin"
fi
if cmdExists go; then
  export GOPATH="${HOME}/.local/go"
  export GOBIN="${GOPATH}/bin"
  export PATH="${PATH}:${GOBIN}"
  if [[ ! -d "${GOBIN}" ]]; then
    mkdir -p "${GOBIN}" 
  fi

  # TODO: Make an associative array and test if all the binaries exist
  # Install go plugins
  # for MOD in 'antonmedv/fx@24.0.0' 'andreazorzetto/yh@v0.4.0' 'cpuguy83/go-md2man/v2@v2.0.2'
  # do
    # go install "github.com/${MOD}"
  # done;
fi

if cmdExists java; then
  # Get the symlink target from java executable in PATH, then calculate JAVA_HOME
  # by removing '/bin/java' from the end of the path which readlink gives
  export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"
fi

if [[ -d "${HOME}/.poetry/bin" ]]; then
  export PATH="${HOME}/.poetry/bin:${PATH}"
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

# TODO: Replace zplug with a better solution
# https://www.reddit.com/r/zsh/comments/ak0vgi/a_comparison_of_all_the_zsh_plugin_mangers_i_used/
# https://www.reddit.com/r/zsh/comments/1etl9mz/fastest_plugin_manager/
# Check if zplug is installed
if cmdExists gawk; then
  if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
  fi
else
  echo "Please install gawk";
fi

source ~/.zplug/init.zsh

##################################zsh plugins######################################

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "romkatv/powerlevel10k", as:theme, depth:1

# TODO: Figure out a better solution for binaries
# Can't compile direnv without go
# if cmdExists go; then
 #  zplug "direnv/direnv", as:command, rename-to:direnv, use:"direnv", at:v2.23.3 hook-build:"make"
# fi

# Use oh my zsh defaults because we <3 it!
local omzLibs=(
  clipboard
  compfix
  completion
  correction
  diagnostics
  directories
  functions
  git
  grep
  history
  key-bindings
  misc
  nvm
  prompt_info_functions
  spectrum
  termsupport
  theme-and-appearance
)

for lib in "${omzLibs[@]}"; do
  zplug "lib/${lib}", from:oh-my-zsh, depth:1
done;

# Use cool oh my zsh plugins!
local omzPlugins=(
  catimg
  colored-man-pages
  colorize
  command-not-found
  # This is causing some headache, don't install it for now
  # direnv
  fancy-ctrl-z
  fd
  git-auto-fetch
  kubectl
  man
  ssh-agent
  # TODO: Figure out forwarding of GPG keys
  # gpg-agent
  sudo
  z
  zsh-interactive-cd
)

for PLUGIN in "${omzPlugins[@]}"; do
  zplug "plugins/${PLUGIN}", from:oh-my-zsh, depth:1
done;

zplug 'junegunn/fzf', depth:1, hook-build:'./install --key-bindings --completion --no-update-rc --no-fish'

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

##################################fix/config for plugins######################################
# For some reason some plugins put their completion list in
# $ZSH_CACHE_DIR/completion but that dir does not exist by default, so create it here
# Can't do this before zplug load because $ZSH & ZSH_CACHE_DIR is exported after load
# TODO: Put this in a custom plugin
mkdir -p "${ZSH_CACHE_DIR}completions"

if cmdExists direnv; then
  # supress DIRENV messages for instant prompt, comment the line below for debugging DIRENV
  export DIRENV_LOG_FORMAT=
  eval "$(direnv hook zsh)"
fi

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

# Enable Asynchronous Mode for suggestions
export ZSH_AUSOSUGGEST_USE_ASYNC=true

# Override oh-my-zsh history size
export HISTSIZE=100000
export SAVEHIST=${HISTSIZE}

# Stop using pushd like a crazy person
unsetopt auto_pushd

# Only enable this once you have zsh 5.7 or greater
[[ "$COLORTERM" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor

##################################Load custom files######################################
for file in vars aliases func; do
  [[ ! -f "${HOME}/.shell/${file}.sh" ]] || source "${HOME}/.shell/${file}.sh"
done

##################################Custom function Configs######################################
# Set up proxy if in VPN or not
[[ "${ALWAYS_PROXY_PROBE}" == "true" ]] && proxyProbe

# Load Angular CLI autocompletion.
# source <(ng completion script)

##################################Misc######################################
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="${PATH}:/home/revan/perl5/bin"
PERL5LIB="/home/revan/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/revan/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/revan/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/revan/perl5"; export PERL_MM_OPT;
