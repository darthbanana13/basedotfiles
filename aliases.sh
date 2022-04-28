#Copy to clipboard
alias xc="xclip -selection c"

#Paste from clipboard
alias xp="xclip -selection clipboard -o"

#Make the dirs command useful
alias dirs="dirs -v"

alias jenkins-cli="JENKINS_USER_ID=${JENKINS_USER_ID} JENKINS_API_TOKEN=${JENKINS_API_TOKEN} java -jar ${HOME}/Apps/jenkins-cli.jar -webSocket -s ${JENKINS_URL}"
