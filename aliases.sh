if [[ "${XDG_SESSION_TYPE}" == 'wayland' ]]; then
  if cmdExists wl-copy; then
    alias tc='wl-copy'
    alias tp='wl-paste'
  else
    alias tc='echo "Please install wl-clipboard for clipboard support in wayland!"'
    alias tp='echo "Please install wl-clipboard for clipboard support in wayland!"'
  fi
elif [[ "${XDG_SESSION_TYPE}" == 'x11' ]]; then
  if cmdExists xclip; then
    alias tc='xclip -selection c'
    alias tp='xclip -selection clipboard -o'
  else
    alias tc='echo "Please install xclip for clipboard support in X11!"'
    alias tp='echo "Please install xclip for clipboard support in X11!"'
  fi
elif cmdExists termux-clipboard-get; then 
  alias tc='termux-clipboard-get'
  alias tp='termux-clipboard-set'
fi

alias dirs='dirs -v' # Make the dirs command useful

cmdExists lsd && alias ls='lsd' # Color ls

# Safer rm, got burned too many times by undoable rm
# This should not interfere with your shell scripts, because IMO most of them
# use either bash or sh.
if cmdExists trash-put; then
  alias rm='echo "Please use trash-put"'
fi

alias ssh='ssh -o AddKeysToAgent=yes' # For enabling lazy loading of ssh keys

alias bash='PERMIT_BASH=true bash' # Make using bash interactively possible

# Make sure we make an alias from vi & vim to nvim here, because a symlink might
# not be installed automatically for nvim. Use update-alternatives for debian
# based systems. If unable then we'll set up aliases here:
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

# Edit neovim config
[[ -d "${XDG_CONFIG_HOME}/nvim" ]] && alias en="${EDITOR} ${XDG_CONFIG_HOME}/nvim"

# Use a better top utility if it exists
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
alias ev="${EDITOR} ${XDG_CONFIG_HOME}/zsh/vars.sh"

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
