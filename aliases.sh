# TODO: This needs some work, in case wayland is used
if cmdExists xclip; then
  #Copy to clipboard
  alias xc="xclip -selection c"

  #Paste from clipboard
  alias xp="xclip -selection clipboard -o"
elif cmdExists termux-clipboard-get; then 
  alias xc="termux-clipboard-get"
  alias xp="termux-clipboard-set"
fi

# Make the dirs command useful
alias dirs="dirs -v"

# Color ls
cmdExists lsd && alias ls='lsd'

# Use Mosh instead of SSH
# cmdExists mosh && alias ssh='mosh'

# For enabling lazy loading of ssh keys
alias ssh='ssh -o AddKeysToAgent=yes'

# Don' make using bash interactively impossible
alias bash="PERMIT_BASH=true bash"

# Make sure we make an alias from vi & vim to nvim here, because a symlink might not be installed automatically for nvim
# Update: Usually use update-alternatives for debian based systems. There is an example in the bootstraps folder.
# Otherwise this will overrider the update-alternatives
# if cmdExists nvim; then
#   alias vi=nvim
#   alias vim=nvim
# fi

# Don't see any reason why we should not use a better top utility if it exists
cmdExists btop && alias top='btop'

# Use cat on steroids if it exists, and don't page, like cat does
# If you don't like the paging behaviour use bat directly
cmdExists bat && alias cat='bat --paging=never'

#Edit .zshrc
alias ez="${EDITOR} ${HOME}/.zshrc"

#Edit functions
alias ef="${EDITOR} ${HOME}/.shell/func.sh"

#Edit variables
alias ev="${EDITOR} ${HOME}/.shell/vars.sh"

#Edit aliases
alias ea="${EDITOR} ${HOME}/.shell/aliases.sh"

#Open editor in current directory
alias e="${EDITOR} ."

##################################Suffix alias######################################
alias -s go="${EDITOR}"
alias -s md="${EDITOR}"
alias -s yaml="${EDITOR}"
alias -s yml="${EDITOR}"
alias -s js="${EDITOR}"
alias -s ts="${EDITOR}"
alias -s json="${EDITOR}"
