# .zshrc

# If not using chsh, then make sure SHELL value is sane
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

if cmdExists tmux && [[ -z "${TMUX}" ]]; then
   tmux attach 2> /dev/null || tmux
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# TODO: Replace zplug with a better solution
# https://www.reddit.com/r/zsh/comments/ak0vgi/a_comparison_of_all_the_zsh_plugin_mangers_i_used/
# https://www.reddit.com/r/zsh/comments/1etl9mz/fastest_plugin_manager/
# Transition to zsh4humans
# Check if zplug is installed
if cmdExists gawk && cmdExists git; then
  if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
  fi
else
  echo "Please install gawk & git";
fi

source ~/.zplug/init.zsh

##################################zsh plugins######################################

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug 'romkatv/powerlevel10k', as:theme, depth:1
#
# Fish shell like autosuggestions
zplug "zsh-users/zsh-autosuggestions", depth:1
zplug "zsh-users/zsh-syntax-highlighting", depth:1

# Use oh my zsh defaults because we <3 it!
local omzLibs=(
  'async_prompt'
  'clipboard'
  'compfix'
  'completion'
  'correction'
  'diagnostics'
  'directories'
  'functions'
  'git'
  'grep'
  'history'
  'key-bindings'
  'misc'
  'prompt_info_functions'
  'spectrum'
  'termsupport'
  'theme-and-appearance'
  'vcs_info'
)

for lib in "${omzLibs[@]}"; do
  zplug "lib/${lib}", from:oh-my-zsh, depth:1
done;

# Use cool oh my zsh plugins!
local omzPlugins=(
  'catimg'
  'colored-man-pages'
  'colorize'
  'command-not-found'
  'fancy-ctrl-z'
  'fnm'
  'fzf'
  'git-auto-fetch'
  'kubectl'
  'man'
  # 'gpg-agent'   # TODO: Figure out forwarding of GPG keys
  'sudo'
  'z'
  'zsh-interactive-cd'
)

for PLUGIN in "${omzPlugins[@]}"; do
  zplug "plugins/${PLUGIN}", from:oh-my-zsh, depth:1
done;

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

# Only enable this once you have zsh 5.7 or greater
[[ "$COLORTERM" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor

##################################Load custom files######################################
for file in zsh paths vars aliases func; do
  [[ ! -f "${XDG_CONFIG_HOME}/zsh/${file}.sh" ]] || source "${XDG_CONFIG_HOME}/zsh/${file}.sh"
done

##################################Custom function Configs######################################
# Set up proxy if in VPN or not
[[ "${ALWAYS_PROXY_PROBE}" == "true" ]] && proxyProbe

# Start sshAgent automatically
[[ "${AUTOSTART_SSH_AGENT}" == "true" ]] && sshAgent

# Setup system specific PATHs
[[ -n "${PATH_ADD}" ]] && export PATH="${PATH}:${PATH_ADD}"

##################################Misc######################################
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
