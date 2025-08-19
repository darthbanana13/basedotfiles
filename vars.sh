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

# Make Neovim or the lowest common denominator that's aliased or symlinked to
# the vi command the default editor
export EDITOR=vi

# Use Docker BuildKit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Always opt out of the .NET telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# fzf config
export FZF_TMUX_OPTS="-p 95%,60%"

# Add more things to PATH only specific to this specific system
PATH_ADD=""

AUTOSTART_SSH_AGENT="true"
