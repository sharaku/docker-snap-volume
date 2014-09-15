#!/bin/sh

# By the following environment variables, to change the control
# ENV VOLUME_DATA data:/opt/data
# ENV VOLUME_SNAP /opt/.snap
# ENV SNAP_MAX 128
# ENV SNAP_CRON 0 3 * * *

# 設定の追加
VOLUME_DATA=`echo ${1} | cut -d : -f1`:`echo ${1} | cut -d : -f2`
shift
while [ "$1" != "" ]
do
  VOLUME_DATA=${VOLUME_DATA},`echo ${1} | cut -d : -f1`:`echo ${1} | cut -d : -f2`
  shift
done

# -----------------------------------------------------------
# update snaapshot param
cat << EOF > ${SNAPSHOTCONF}
VOLUME_SNAP=${VOLUME_SNAP}
VOLUME_DATA=${VOLUME_DATA}
SNAP_MAX=${SNAP_MAX}
EOF

# -----------------------------------------------------------
# create snapshot dir
if [ -e ${VOLUME_SNAP}/snapshot/ ]; then
  echo "" > /dev/null
else
  mkdir ${VOLUME_SNAP}/snapshot/
fi

# -----------------------------------------------------------
# create tag dir
if [ -e ${VOLUME_SNAP}/tag/ ]; then
  echo ""
else
  mkdir ${VOLUME_SNAP}/tag/
fi

# Set the crontab based on the specified environment variable
# Argument that you specify to the original environment variable
echo "${SNAP_CRON} root /opt/snap.sh ${VOLUME_DATA} ${VOLUME_SNAP} ${SNAP_MAX}" >> /etc/crontab

# Starting the cron
# Because there is no need for storage, process ID, etc. only to start
cron

# I want to not to kill the process
exec tail -f /dev/null

