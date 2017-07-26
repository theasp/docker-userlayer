# User info
USER_PASSWORD="${USER_PASSWORD:-*}"

USE_SSH_AGENT=${USE_SSH_AGENT:-true}
USER_NAME="${USER_NAME:-ubuntu}"
USER_GROUP="${USER_GROUP:-$USER_NAME}"
USER_UID="${USER_UID:-1000}"
USER_GID="${USER_GID:-${USER_UID}}"
USER_SHELL="${USER_SHELL:-/bin/bash}"
USER_HOME="${USER_HOME:-/home/${USER_NAME}}"
USER_GECOS="${USER_GECOS:-Unknown}"

export USER=$USER_NAME
export FULLNAME=$USER_GECOS
export HOME=$USER_HOME
export SHELL=$USER_SHELL

log debug "user: Creating user..."
# Create the user, if it doesn't exist
addgroup --gid ${USER_GID} ${USER_GROUP} > /dev/null
adduser --disabled-password --home ${USER_HOME} --shell ${USER_SHELL} --uid ${USER_UID} --gid ${USER_GID} --gecos "$USER_GECOS" ${USER_NAME} > /dev/null

# Make sure various directories exist
mkdir -p /app/log
mkdir -p /app/supervisord.d

# Change the user's password
if [[ -n ${USER_PASSWORD} ]]; then
  chpasswd -e <<<"${USER_NAME}:${USER_PASSWORD}"
fi

unset USER_PASSWORD
export USER_PASSWORD

log info "user: Created user $USER_NAME."
