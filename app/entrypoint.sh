#!/bin/bash

set -e

LIBDIR=$(dirname $0)
SHNAME=$(basename $0)
source $LIBDIR/andrew-lib.sh

for service in /app/entrypoint.d/*.bash; do
  if [[ -f $service ]]; then
    source $service
  fi
done
