if [[ ${ENABLE_SUPERVISOR:-true} = true ]]; then
  exec supervisord --nodaemon --configuration /app/supervisord.conf
fi
