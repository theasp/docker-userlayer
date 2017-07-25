#!/bin/bash

IFS=: read USER_NAME _ USER_UID USER_GID USER_GECOS USER_HOME USER_SHELL < <(getent passwd $(id -u))

function is_running {
  docker container inspect "$1" > /dev/null 2>&1
}

function is_existing {
  docker container inspect "$1" > /dev/null 2>&1
}

function do_status {
  if is_running $CONTAINER; then
    echo "Container $CONTAINER is running."
    exit 0
  else
    echo "Container $CONTAINER is not running."
    exit 1
  fi
}

function do_start {
  if ! is_running $CONTAINER; then
    docker container run \
           --detach \
           --rm \
           --name "$CONTAINER" \
           -v "$HOME:$HOME" \
           -v "$SSH_AUTH_SOCK:/tmp/.ssh-agent" \
           -v "/tmp/.X11-unix:/tmp/.X11-unix" \
           -e "SSH_AUTH_SOCK=/tmp/.ssh-agent" \
           -e "USER_NAME=$USER_NAME" \
           -e "USER_UID=$USER_UID" \
           -e "USER_GID=$USER_GID" \
           -e "USER_HOME=$USER_HOME" \
           -e "USER_GECOS='$USER_GECOS'" \
           theasp/userlayer
    echo "Container $CONTAINER started."
    exit 0
  else
    echo "Container $CONTAINER already started."
    exit 0
  fi
}

function do_stop {
  if is_running $CONTAINER; then
    docker container stop "$CONTAINER" || true
    docker container rm "$CONTAINER" || true
    echo "Container $CONTAINER stopped."
    exit 0
  else
    echo "Container $CONTAINER already stopped."
    exit 0
  fi
}

function do_exec {
  CMD=${1:-bash}
  shift

  echo "Executing $CMD on $CONTAINER"
  if is_running $CONTAINER; then
    set -x
    exec docker container exec \
         --interactive \
         --tty \
         --user $USER_NAME \
         -e "SSH_AUTH_SOCK=/tmp/.ssh-agent" \
         -e "DISPLAY=$DISPLAY" \
         $CONTAINER "$CMD" "$@"
  else
    echo "Container $CONTAINER already stopped."
    exit 0
  fi
}

FUNC=$1
shift

CONTAINER="userlayer_${USER_NAME}_default"

case $FUNC in
  status)    do_status;;
  start|up)  do_start;;
  stop|down) do_stop;;
  exec)      do_exec "$@";;
esac            


NAME=${1:-$USER_NAME}

