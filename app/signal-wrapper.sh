#!/bin/bash

set -e

LIBDIR=$(dirname $0)
SHNAME=$(basename $0)
source $LIBDIR/andrew-lib.sh

STARTCMD=$1
STOPCMD=$2
CHECKCMD=$3

function usage {
  echo "Usage: $SHNAME <start-command> <stop-command> [check-command]"
}

if [[ -z $STARTCMD ]] || [[ -z $STOPCMD ]]; then
  usage 1>&2
  exit 1
fi

function do_start {
  debug "do_start"
  if [[ -z $CHECKCMD ]] || ! (eval $CHECKCMD); then
    info "Starting: $STARTCMD"
    (eval $STARTCMD)
  else
    info "Already running: $STARTCMD"
  fi
}

function do_stop {
  debug "do_stop"
  if [[ -z $CHECKCMD ]] || (eval $CHECKCMD); then
    info "Stopping: $STOPCMD"
    (eval $STOPCMD)
  else
    info "Already stopped: $STOPCMD"
  fi
}

function do_restart {
  debug "do_restart"
  do_stop
  do_start
}

function signal_handler {
  debug "signal"
  do_stop
  exit 0
}

debug "PID: $$"

trap signal_handler TERM KILL HUP INT SIGTERM SIGKILL SIGINT
trap do_restart SIGHUP


do_start

info "Started $STARTCMD, waiting for signals"
while sleep 10; do
  if [[ $CHECKCMD ]] && ! (eval $CHECKCMD); then
    break
  fi
done
