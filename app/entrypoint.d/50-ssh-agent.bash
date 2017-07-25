log info "ssh-agent: Configuring..."
if [[ ${ENABLE_SSH:-true} = true ]]; then
  export SSH_AUTH_SOCK=${SSH_AUTH_SOCK:-/tmp/.ssh-agent}

  if [[ -e "$SSH_AUTH_SOCK" ]]; then
    log info "ssh-agent: Detected $SSH_AUTH_SOCK, disabling service."
  else
    log info "ssh-agent: Enabling service."
    USER_NAME=$USER_NAME envsubst < /app/supervisord.d/ssh-agent.envsubst > /app/supervisord.d/ssh-agent.conf
  fi
fi
