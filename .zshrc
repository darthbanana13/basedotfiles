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
if cmdExists tmux; then
  if [[ -z ${TMUX} ]]; then # if no session is started, start a new session
    tmux attach 2> /dev/null || tmux
  fi
fi
# cmdExists tmux && [[ -z ${TMUX} ]] && tmux attach 2> /dev/null || tmux

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
export DEFAULT_USER=`whoami`

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
DOTNET_CLI_TELEMETRY_OPTOUT=1

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
ZSH_AUSOSUGGEST_USE_ASYNC=true

# Override oh-my-zsh history size
HISTSIZE=100000
SAVEHIST=100000

# Stop using pushd like a crazy person
unsetopt auto_pushd

# Only enable this once you have zsh 5.7 or greater
[[ "$COLORTERM" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor

##################################Load custom variables######################################
if [[ -f ~/.vars.sh ]]; then
  source ~/.vars.sh
fi

##################################Windows (is special) quirks######################################
DOTNET_CLI_TELEMETRY_OPTOUT=1

if [[ -d "/mnt/c/Windows" ]]; then
  export DISPLAY=$(/mnt/c/Windows/System32/ipconfig.exe | grep -A 5 "vEthernet (WSL)" | grep -oP '(?<=IPv4 Address(?:\.\s){11}:\s)((?:\d+\.){3}\d+)'):0.0
  export LIBGL_ALWAYS_INDIRECT=1
  
  # Start Docker daemon automatically when logging in
  # RUNNING=`ps aux | grep dockerd | grep -v grep`
  # if [ -z "$RUNNING" ]; then
    # sudo dockerd > /dev/null 2>&1 &
    # disown
  # fi
fi

##################################Proxy######################################
proxyUnset() {
  unset http_proxy
  unset HTTP_PROXY
  unset https_proxy
  unset HTTPS_PROXY
  unset ftp_proxy
  unset FTP_PROXY
  unset all_proxy
  unset ALL_PROXY
  unset PIP_PROXY
  unset no_proxy
  unset NO_PROXY
  unset MAVEN_OPTS
}

composeProxyAddr() {
  if [[ $# != 3 ]] ; then
    exit 1;
  fi

  local proxyProtocol="${1}"
  local proxyHost="${2}"
  local proxyPort="${3}"

  echo "${proxyProtocol}://${proxyHost}:${proxyPort}"
}

proxySet() {
  if [[ $# -lt 3 ]] ; then
    echo "WTF?"
    exit 1
  fi

  local proxyProtocol="${1}"
  local proxyHost="${2}"
  local proxyPort="${3}"
  local noProxy="${4}"
  local proxyAddr="$(composeProxyAddr ${proxyProtocol} ${proxyHost} ${proxyPort})"

  export http_proxy="${proxyAddr}"
  export HTTP_PROXY="${proxyAddr}"
  export https_proxy="${proxyAddr}"
  export HTTPS_PROXY="${proxyAddr}"
  export ftp_proxy="${proxyAddr}"
  export FTP_PROXY="${proxyAddr}"
  export all_proxy="${proxyAddr}"
  export ALL_PROXY="${proxyAddr}"
  export PIP_PROXY="${proxyAddr}"
  export no_proxy="${noProxy}"
  export NO_PROXY="${noProxy}"
  export MAVEN_OPTS="-Dhttp.proxyHost=${proxyHost} -Dhttp.proxyPort=${proxyPort} -Dhttps.proxyHost=${proxyHost} -Dhttps.proxyPort=${proxyPort}"
}

proxyProbe() {
  if nc -z -w 3 ${PROXY_HOST} ${PROXY_PORT} &> /dev/null; then
    # echo "proxyProbe: Detected corproot network, turning on proxy."
    proxySet "${PROXY_PROTOCOL}" "${PROXY_HOST}" "${PROXY_PORT}" "${NOPROXY}"
  else
    # echo "proxyProbe: Detected normal network, turning off proxy."
    proxyUnset
  fi
}

awsProxy() {
  local proxyArgs=("${AWS_PROXY_PROTOCOL}" "${AWS_PROXY_HOST}" "${AWS_PROXY_PORT}")
  local proxyAddr="$(composeProxyAddr ${proxyArgs[@]})"

  if [[ "${http_proxy}" != "${proxyAddr}" ]]; then
    proxySet ${proxyArgs[@]}
  else
    proxyUnset
  fi
}

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
