#!/bin/sh

# By the following environment variables, to change the control
# ENV VOLUME_DATA /opt/data
# ENV VOLUME_SNAP /opt/.snap
# ENV SNAP_MAX 128
# ENV SNAP_CRON 0 3 * * *

# Set the crontab based on the specified environment variable
# Argument that you specify to the original environment variable
echo "${SNAP_CRON} root /opt/snap.sh ${VOLUME_DATA} ${VOLUME_SNAP} ${SNAP_MAX}" >> /etc/crontab

# Starting the cron
# Because there is no need for storage, process ID, etc. only to start
cron

# I want to not to kill the process
exec tail -f /dev/null

