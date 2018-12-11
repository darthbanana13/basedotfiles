# Make sure you have gawk installed otherwise zplug insall will fail
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# check if lauched it GUI terminal, if so start TMUX automatically
if [[ -n "$KONSOLE" ]] ;then
    if which tmux >/dev/null 2>&1; then
        # if no session is started, start a new session
        test -z ${TMUX} && tmux

        # when quitting tmux, try to attach
        while test -z ${TMUX}; do
            tmux attach || break
        done
    fi
fi

# Composer path
export PATH="$PATH:$HOME/.local/bin:/opt/mssql-tools/bin:$HOME/.composer/vendor/bin"

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
DEFAULT_USER=`whoami`

XDG_CONFIG_HOME=~/.config/powerline
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa


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
# TODO: Customize the theme already!
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

# Use oh my zsh defaults because we <3 it!
for LIB in compfix completion correction diagnostics directories functions git grep history key-bindings misc nvm prompt_info_functions spectrum termsupport theme-and-appearance ssh-agent kubectl
do
    zplug "lib/${LIB}", from:oh-my-zsh
done;

zplug "plugins/fancy-ctrl-z", from:oh-my-zsh

# True men compile their fzf plugin
zplug 'junegunn/fzf', depth:1, hook-build:'./install --key-bindings --completion --no-update-rc --64 --no-bash --no-fish'
zplug "zuxfoucault/colored-man-pages_mod"
# zplug "arzzen/calc.plugin.zsh"
# Fish shell like autosuggestions
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

##################################plugins for others######################################

zplug "tmux-plugins/tpm"

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
setopt monitor


# Because fzf likes to make a file in the home directory, enable it manually here
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Codeception autocompletion
# CODECEPT_PATH="${HOME}/.composer/vendor/codeception/codeception/codecept"
# [ -f $CODECEPT_PATH ] && source <($CODECEPT_PATH _completion --generate-hook --program codecept --use-vendor-bin)

#Enable Asynchronous Mode for suggestions
ZSH_AUSOSUGGEST_USE_ASYNC=true

# Override oh-my-zsh history size
HISTSIZE=100000
SAVEHIST=100000

# Stop using pushd like a crazy person
unsetopt auto_pushd

# The future is here! Intelgent Ag
if which ag &> /dev/null; then
    alias afind="ag -il"
fi

# LS_COLORS=$(ls_colors_generator)

# run_ls() {
    # ls-i --color=auto -w $(tput cols) "$@"
# }

# run_dir() {
    # dir-i --color=auto -w $(tput cols) "$@"
# }

# run_vdir() {
    # vdir-i --color=auto -w $(tput cols) "$@"
# }

##################################Aliases######################################

# alias ls="run_ls"
# alias dir="run_dir"
# alias vdir="run_vdir"

#Copy to clipboard
alias xc="xclip -selection c"

#Paste from clipboard
alias xp="xclip -selection clipboard -o"

alias glances="glances 2> /dev/null"