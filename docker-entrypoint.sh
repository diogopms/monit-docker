#!/bin/sh

chmod 700 /etc/monitrc
cp /etc/monitrc /etc/monitrc_root
chown root:root /etc/monitrc_root

if [ "$DEBUG" = "1" ]
then
  exec monit -I -B -v -c /etc/monitrc_root
else

  exec "$@"
fi
