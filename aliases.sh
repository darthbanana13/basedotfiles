if cmdExists xclip; then
  #Copy to clipboard
  alias xc="xclip -selection c"

  #Paste from clipboard
  alias xp="xclip -selection clipboard -o"
elif cmdExists termux-clipboard-get; then 
  alias xc="termux-clipboard-get"
  alias xp="termux-clipboard-set"
fi

#Make the dirs command useful
alias dirs="dirs -v"

#Shortcut for Jenkins CLI
if cmdExists java && [[ -f "${HOME}/Apps/jenkins-cli.jar" ]]; then
  alias jenkins-cli="JENKINS_USER_ID=${JENKINS_USER_ID} JENKINS_API_TOKEN=${JENKINS_API_TOKEN} java -jar ${HOME}/Apps/jenkins-cli.jar -webSocket -s ${JENKINS_URL}"
fi

# Color ls
cmdExists lsd && alias ls='lsd'

# Don' make using bash interactively impossible
alias bash="PERMIT_BASH=true bash"

#Edit .zshrc
alias ez="${EDITOR} ${HOME}/.zshrc"

#Edit functions
alias ef="${EDITOR} ${HOME}/.shell/func.sh"

#Edit variables
alias ev="${EDITOR} ${HOME}/.shell/vars.sh"

#Edit aliases
alias ea="${EDITOR} ${HOME}/.shell/aliases.sh"

#Open editor in current directory
alias .="${EDITOR} ."

##################################Suffix alias######################################
alias -s go="${EDITOR}"
alias -s php="${EDITOR}"
alias -s md="${EDITOR}"
alias -s py="${EDITOR}"
alias -s yaml="${EDITOR}"
alias -s yml="${EDITOR}"
alias -s js="${EDITOR}"
alias -s ts="${EDITOR}"
alias -s json="${EDITOR}"