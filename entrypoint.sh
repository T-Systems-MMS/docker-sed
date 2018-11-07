#!/bin/sh

if [ -n "${USERID}" ]; then
  echo "auser:x:${USERID}:${GROUPID}:auser:/work:/bin/ash" >>/etc/passwd
  exec sudo -u auser $@
else
  exec $@
fi
