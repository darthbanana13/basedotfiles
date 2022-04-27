#File ~/.oh-my-zsh/custom/aliases.zsh

#Copy to clipboard
alias xc="xclip -selection c"

#Paste from clipboard
alias xp="xclip -selection clipboard -o"

#Make the dirs command useful
alias dirs="dirs -v"

alias jenkins-cli="JENKINS_USER_ID=taamarah JENKINS_API_TOKEN=117a80a8ebf5e9b7b5d5bc7356a9da13c7 java -jar ${HOME}/Apps/jenkins-cli.jar -webSocket -s 'https://eur-jenkins.dos.corproot.net'"
