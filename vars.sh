export PROXY_PROTOCOL=""
export PROXY_HOST=""
export PROXY_PORT=""
export NOPROXY=""
export NO_PROXY_DNS=""
export PROXY_DNS=""

export ALWAYS_PROXY_PROBE=""

export K3S_KUBECONFIG_MODE="644"

export BROWSER=""

export DONT_PROMPT_WSL_INSTALL=true

# Set our username so the prompt hides it
export DEFAULT_USER="$(whoami)"

# Add local bin directories to PATH
export PATH="${PATH}:${HOME}/.local/bin"

# Make VIM the default editor
export EDITOR=vim

# Use Docker BuildKit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Always opt out of the .NET telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# fzf config
export FZF_TMUX_OPTS="-p 95%,60%"

# set up autosuggestion
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Enable Asynchronous Mode for suggestions
export ZSH_AUSOSUGGEST_USE_ASYNC=true

# Override oh-my-zsh history size
export HISTSIZE=100000
export SAVEHIST=${HISTSIZE}

# Add more things to PATH only specific to this specific system
export PATH_ADD=""
