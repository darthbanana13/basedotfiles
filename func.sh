proxyUnset() {
  unset http_proxy
  unset HTTP_PROXY
  unset https_proxy
  unset HTTPS_PROXY
  unset ftp_proxy
  unset FTP_PROXY
  unset all_proxy
  unset ALL_PROXY
  unset PIP_PROXY
  unset no_proxy
  unset NO_PROXY
  unset MAVEN_OPTS
}

composeProxyAddr() {
  if (( $# != 3 )) ; then
    return 1;
  fi

  local proxyProtocol="${1}"
  local proxyHost="${2}"
  local proxyPort="${3}"

  echo "${proxyProtocol}://${proxyHost}:${proxyPort}"
}

proxySet() {
  if (( $# < 3 )) ; then
    echo "Syntax: proxySet proxyProtocol proxyHost proxyPort [noProxy]"
    return 1
  fi

  local proxyProtocol="${1}"
  local proxyHost="${2}"
  local proxyPort="${3}"
  local noProxy="${4}"
  local proxyAddr="$(composeProxyAddr ${proxyProtocol} ${proxyHost} ${proxyPort})"

  export http_proxy="${proxyAddr}"
  export HTTP_PROXY="${proxyAddr}"
  export https_proxy="${proxyAddr}"
  export HTTPS_PROXY="${proxyAddr}"
  export ftp_proxy="${proxyAddr}"
  export FTP_PROXY="${proxyAddr}"
  export all_proxy="${proxyAddr}"
  export ALL_PROXY="${proxyAddr}"
  export PIP_PROXY="${proxyAddr}"
  export no_proxy="${noProxy}"
  export NO_PROXY="${noProxy}"
  export MAVEN_OPTS="-Dhttp.proxyHost=${proxyHost} -Dhttp.proxyPort=${proxyPort} -Dhttps.proxyHost=${proxyHost} -Dhttps.proxyPort=${proxyPort}"
}

RESOLF='/etc/resolv.conf'
changeDNS() {
  if (( $# < 1 )) ; then
    return 1;
  fi

  local nameservers=("${(@s/,/)1}")

  sudo truncate -s 0 "${RESOLF}"
  for nameServerIP in ${nameservers[@]}; do
    echo "nameserver ${nameServerIP}" | sudo tee -a "${RESOLF}" > /dev/null
  done
}

changeWSLDNS() {
  sudo chattr -i "${RESOLF}"
  changeDNS "${1}"
  sudo chattr +i "${RESOLF}"
}

proxyProbe() {
  local matchDNS="dns"
  local withDNS="${1}"
  if nc -z -w 3 ${PROXY_HOST} ${PROXY_PORT} &> /dev/null; then
    # echo "proxyProbe: Detected VPN, turning on proxy."
    proxySet "${PROXY_PROTOCOL}" "${PROXY_HOST}" "${PROXY_PORT}" "${NOPROXY}"
    if [[ "${(L)withDNS}" = "${matchDNS}" ]]; then
      changeWSLDNS "${PROXY_DNS},${NO_PROXY_DNS}"
    fi
  else
    # echo "proxyProbe: Detected normal network, turning off proxy."
    proxyUnset
    if [[ "${(L)withDNS}" = "${matchDNS}" ]]; then
      changeWSLDNS "${NO_PROXY_DNS},${PROXY_DNS}"
    fi
  fi
}

awsProxy() {
  local proxyArgs=("${AWS_PROXY_PROTOCOL}" "${AWS_PROXY_HOST}" "${AWS_PROXY_PORT}")
  local proxyAddr="$(composeProxyAddr ${proxyArgs[@]})"

  if [[ "${http_proxy}" != "${proxyAddr}" ]]; then
    proxySet ${proxyArgs[@]}
  else
    proxyUnset
  fi
}

changeCluster() {
  local clusterName="${1:-$AWS_CLUSTER_NAME}"
  export AWS_CLUSTER_NAME="${clusterName}"
  aws eks update-kubeconfig --name "${AWS_CLUSTER_NAME}" --region "${AWS_REGION}"
}

wslSetDisplay() {
  local ipconfig="/mnt/c/Windows/System32/ipconfig.exe"
  local grepip=("grep" "-oP" '(?<=IPv4 Address(?:\.\s){11}:\s)((?:\d+\.){3}\d+)')

  if [[ ! -d "/mnt/c/Windows" ]]; then
    return
  fi

  local display=$("${ipconfig}" | grep -A 3 "${ENTERPRISE_DOMAIN}" | "${grepip[@]}")
  if [[ -n "${display}" ]]; then
    export DISPLAY="${display}:0.0"
    return
  fi
  export DISPLAY=$("${ipconfig}" | grep -A 5 "vEthernet (WSL)" | "${grepip[@]}"):0.0
}

#SSH Reagent (http://tychoish.com/post/9-awesome-ssh-tricks/)
sshReagent () {
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

sshAgent() {
  pgrep -x ssh-agent &> /dev/null && sshReagent &> /dev/null || eval $(ssh-agent) &> /dev/null
}
