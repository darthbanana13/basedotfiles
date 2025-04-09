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

# Since we lazy load nvm (node & npm) make sure they're loaded before nvim
# starts otherwise some plugins (like copilot) will complain
alias -g editor_cmd="node --version &> /dev/null && ${EDITOR}"

#Edit .zshrc
alias ez="editor_cmd ${HOME}/.zshrc"

#Edit functions
alias ef="editor_cmd ${HOME}/.shell/func.sh"

#Edit variables
alias ev="editor_cmd ${HOME}/.shell/vars.sh"

#Edit aliases
alias ea="editor_cmd ${HOME}/.shell/aliases.sh"

#Open editor in current directory
alias e="editor_cmd ."

##################################Suffix alias######################################
alias -s go="editor_cmd"
alias -s md="editor_cmd"
alias -s yaml="editor_cmd"
alias -s yml="editor_cmd"
alias -s js="editor_cmd"
alias -s ts="editor_cmd"
alias -s json="editor_cmd"
