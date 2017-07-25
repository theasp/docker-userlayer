if [[ $DEBUG = true ]]; then
  set -x
  export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
fi
