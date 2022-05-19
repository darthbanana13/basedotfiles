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
  if [[ $# != 3 ]] ; then
    exit 1;
  fi

  local proxyProtocol="${1}"
  local proxyHost="${2}"
  local proxyPort="${3}"

  echo "${proxyProtocol}://${proxyHost}:${proxyPort}"
}

proxySet() {
  if [[ $# -lt 3 ]] ; then
    echo "Syntax: proxySet proxyProtocol proxyHost proxyPort [noProxy]"
    exit 1
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

proxyProbe() {
  if nc -z -w 3 ${PROXY_HOST} ${PROXY_PORT} &> /dev/null; then
    # echo "proxyProbe: Detected corproot network, turning on proxy."
    proxySet "${PROXY_PROTOCOL}" "${PROXY_HOST}" "${PROXY_PORT}" "${NOPROXY}"
  else
    # echo "proxyProbe: Detected normal network, turning off proxy."
    proxyUnset
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
  aws eks update-kubeconfig --name $clusterName --region $AWS_REGION
}

setDisplay() {
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
