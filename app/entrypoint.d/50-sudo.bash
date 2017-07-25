if [[ "${ENABLE_SUDO:-true}" = true ]]; then
  echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/userlayer
  log info "sudo: Enabled."
else
  log info "sudo: Disabled."
fi
