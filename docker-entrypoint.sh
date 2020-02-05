#!/bin/sh

if [ "$DEBUG" = "1" ]
then
  exec monit -I -B -v
else
  exec "$@"
fi
