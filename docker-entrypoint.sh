#!/bin/sh
set -e

# Monit refuses configs that are readable by anyone but the owner, so tighten
# the mounted file's permissions and run from a root-owned copy (the mount
# usually belongs to a host user, not root).
if [ -f /etc/monitrc ]; then
  echo "Setting up monitrc"
  chmod 700 /etc/monitrc
  cp /etc/monitrc /etc/monitrc_root
  chown root:root /etc/monitrc_root
fi

echo "Removing prior PID file"
rm -f /var/run/monit.pid

if [ "$DEBUG" = "1" ]; then
  exec monit -I -B -v -c /etc/monitrc_root
fi

exec "$@"
