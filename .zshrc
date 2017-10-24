# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi


#Start Radu
# TMUX
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

export PATH=$PATH:~/.local/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

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
#setopt CORRECT

DEFAULT_USER=`whoami`

XDG_CONFIG_HOME=~/.config/powerline

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
#End Radu


# Essential
source ~/.zplug/init.zsh

# Make sure to use double quotes to prevent shell expansion
zplug "zsh-users/zsh-syntax-highlighting"
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

for LIB in bzr clipboard compfix completion correction diagnostics directories functions git grep history key-bindings misc nvm prompt_info_functions spectrum termsupport theme-and-appearance
do
    zplug "lib/${LIB}", from:oh-my-zsh
done;
# zplug 'junegunn/fzf-bin', as:command, rename-to:fzf
# zplug 'junegunn/fzf', use:"shell/*"
zplug 'junegunn/fzf', as:command, use:'{bin/fzf,shell/*}', depth:1, hook-build:'./install --key-bindings --completion --update-rc --64 --no-bash --no-fish'
# Add a bunch more of your favorite packages!

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