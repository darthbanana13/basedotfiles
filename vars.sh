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

export DEFAULT_USER="$(whoami)" # Set our username so the prompt hides it

export PATH="${PATH}:${HOME}/.local/bin" # Add local bin directories to PATH

# Make Neovim or the lowest common denominator that's aliased or symlinked to
# the vi command the default editor
export EDITOR=vi

# Use Docker BuildKit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

export DOTNET_CLI_TELEMETRY_OPTOUT=1 # Always opt out of the .NET telemetry

export FZF_TMUX_OPTS="-p 95%,60%" # fzf config

# Add more things to PATH only specific to this system (not shared with other computers)
PATH_ADD=""

AUTOSTART_SSH_AGENT="true"
