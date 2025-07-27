if [[ "${XDG_SESSION_TYPE}" == 'wayland' ]]; then
  if cmdExists wl-copy; then
    alias cc='wl-copy'
    alias cp='wl-paste'
  else
    alias cc='echo "Please install wl-clipboard for clipboard support in wayland!"'
    alias cp='echo "Please install wl-clipboard for clipboard support in wayland!"'
  fi
elif [[ "${XDG_SESSION_TYPE}" == 'x11' ]]; then
  if cmdExists xclip; then
    alias cc='xclip -selection c'
    alias cp='xclip -selection clipboard -o'
  else
    alias cc='echo "Please install xclip for clipboard support in X11!"'
    alias cp='echo "Please install xclip for clipboard support in X11!"'
  fi
elif cmdExists termux-clipboard-get; then 
  alias cc='termux-clipboard-get'
  alias cp='termux-clipboard-set'
fi

# Make the dirs command useful
alias dirs='dirs -v'

# Color ls
cmdExists lsd && alias ls='lsd'

# Safer rm
# This should not interfere with your shell scripts, because IMO most of them
# use either bash or sh. And you should do the same! Make scripts for the
# least common denominator!
if cmdExists trash-put; then
  alias rm='echo "Please use trash-put!"'
fi

# Use Mosh instead of SSH
# cmdExists mosh && alias ssh='mosh'

# For enabling lazy loading of ssh keys
alias ssh='ssh -o AddKeysToAgent=yes'

# Don' make using bash interactively impossible
alias bash='PERMIT_BASH=true bash'

# Make sure we make an alias from vi & vim to nvim here, because a symlink might
# not be installed automatically for nvim. Usually use update-alternatives for
# debian based systems. If not then we'll set up aliases here:
if [[ ! -L "$(which ${EDITOR})" ]]; then
  if cmdExits nvim.appimage; then
    alias vi=nvim.appimage
    alias vim=nvim.appimage
    alias nvim=nvim.appimage
  elif cmdExists nvim; then
    alias vi=nvim
    alias vim=nvim
  elif cmdExists vim; then
    alias vi=vim
    alias vim=vim
  fi
fi

# Don't see any reason why we should not use a better top utility if it exists
cmdExists btop && alias top='btop'

# Use cat on steroids if it exists, and don't page, like cat does
# If you don't like the paging behaviour use bat directly
cmdExists bat && alias cat='bat --paging=never'

# Edit shell config
alias es="${EDITOR} ${HOME}/.zshrc"
if [[ -L "${HOME}/.zshrc" ]] && cmdExists readlink && cmdExists dirname; then
  alias es="${EDITOR} $(dirname $(readlink -f ${HOME}/.zshrc))"
fi

# Edit variables
alias ev="${EDITOR} ${HOME}/.shell/vars.sh"

# Open editor in current directory
alias e="${EDITOR} ."

##################################Suffix alias######################################
alias -s go="${EDITOR}"
alias -s md="${EDITOR}"
alias -s yaml="${EDITOR}"
alias -s yml="${EDITOR}"
alias -s js="${EDITOR}"
alias -s ts="${EDITOR}"
alias -s json="${EDITOR}"
