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
export PATH=$PATH:~/.local/bin

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

#allows you to type Bash style comments on your command line
#good 'ol bash
setopt interactivecomments

# Zsh has a spelling corrector
setopt CORRECT

# Set our username so the prompt hides it
DEFAULT_USER=`whoami`

XDG_CONFIG_HOME=~/.config/powerline

#Make the goddamn home & end keys work
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

# This messes up highlight
# zstyle :incremental list yes
# autoload -U incremental-complete-word
# zle -N incremental-complete-word
# bindkey '^X' incremental-complete-word

# Essential for zplug
source ~/.zplug/init.zsh

# Make sure to use double quotes to prevent shell expansioni
# TODO: Customize the theme already!
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

# Use everything for oh-my-zsh for now, because we <3 it!
for LIB in bzr clipboard compfix completion correction diagnostics directories functions git grep history key-bindings misc nvm prompt_info_functions spectrum termsupport theme-and-appearance
do
    zplug "lib/${LIB}", from:oh-my-zsh
done;

# True men compile their fzf plugin
zplug 'junegunn/fzf', depth:1, hook-build:'./install --key-bindings --completion --no-update-rc --64 --no-bash --no-fish'
# Fish shell like autosuggestions
zplug "zsh-users/zsh-autosuggestions"
# zplug 'hchbaw/auto-fu.zsh'
zplug "zuxfoucault/colored-man-pages_mod"
# zplug "arzzen/calc.plugin.zsh"
zplug "zsh-users/zsh-syntax-highlighting"

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load --verbose

# Because fzf likes to make a file in the home directory, enable it manually here
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#Enable Asynchronous Mode for suggestions
ZSH_AUSOSUGGEST_USE_ASYNC=true

# Override oh-my-zsh history size
HISTSIZE=100000
SAVEHIST=100000

#Stop using pushd like a crazy person
unsetopt auto_pushd

# Unfortunatley the below config for auto-fu messes up syntax highliting & suggestions
# until I find a way keep it commented
#
# zle-line-init () {auto-fu-init;}; zle -N zle-line-init
# zstyle ':completion:*' completer _oldlist _complete
# zle -N zle-keymap-select auto-fu-zle-keymap-select
# A=$HOME/.zplug/repos/hchbaw/auto-fu.zsh/auto-fu.zsh; (zsh -c "source $A ; auto-fu-zcompile $A ~/.zsh")
# source ~/.zsh/auto-fu; auto-fu-install

# Use even-better-ls like a B0$$

LS_COLORS=$(ls_colors_generator)

run_ls() {
    ls-i --color=auto -w $(tput cols) "$@"
}

run_dir() {
    dir-i --color=auto -w $(tput cols) "$@"
}

run_vdir() {
    vdir-i --color=auto -w $(tput cols) "$@"
}

##################################Aliases######################################

alias ls="run_ls"
alias dir="run_dir"
alias vdir="run_vdir"

#Copy to clipboard
alias xc="xclip -selection c"

#Paste from clipboard
alias xp="xclip -selection clipboard -o"