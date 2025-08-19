unsetopt auto_pushd # Stop using pushd like a crazy person

unsetopt hist_expire_dups_first # needed for match_prev_cmd
ZSH_AUTOSUGGEST_STRATEGY=(completion match_prev_cmd history) # set up autosuggestion

# Override oh-my-zsh history size
HISTSIZE=10000000
SAVEHIST=${HISTSIZE}

setopt rm_star_wait # if you do a 'rm *', Zsh will make you wait
