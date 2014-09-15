#!/bin/sh
# usage:
#  snap.sh {data dir} {snap dir} {snap max}
DATADIR=${1}
SNAP_BASE=${2}
SNAPSHOT_MAXCNT=${3}

# -----------------------------------------------------------
# snapshotディレクトリを作成する
if [ -e ${SNAP_BASE}/snapshot/ ]; then
  echo "" > /dev/null
else
  mkdir ${SNAP_BASE}/snapshot/
fi

# -----------------------------------------------------------
# I want to back up to SNAP_BASE data DATADIR
# Backup format is as follows
# ${SNAP_BASE}/snapshot//@GMT-2014.08.01-03.00.00
SNAP_HEAD=`ls -1 ${SNAP_BASE}/snapshot | grep "@GMT-" | tail -n 1`
SNAP_DIR='@GMT-'`TZ=GMT date +%Y.%m.%d-%H.%M.%S`
mkdir ${SNAP_BASE}/snapshot/${SNAP_DIR}

if [ `echo "${DATADIR}" | fgrep ','` ]; then
  IFS=,
  for i in $DATADIR
  do
    UNIQNAME=`echo ${i} | cut -d : -f1`
    DATAPATH=`echo ${i} | cut -d : -f2`
    rsync -a --delete --link-dest="${SNAP_BASE}/snapshot/${SNAP_HEAD}/${UNIQNAME}" ${DATAPATH}/ ${SNAP_BASE}/snapshot/${SNAP_DIR}/${UNIQNAME}
  done
else
  UNIQNAME=`echo ${DATADIR} | cut -d : -f1`
  DATAPATH=`echo ${DATADIR} | cut -d : -f2`
  rsync -a --delete --link-dest="${SNAP_BASE}/snapshot/${SNAP_HEAD}/${UNIQNAME}" ${DATAPATH}/ ${SNAP_BASE}/snapshot/${SNAP_DIR}/${UNIQNAME}
fi

# -----------------------------------------------------------
# I want to delete old ones Snapshot of the number of generations or more
SNAPSHOT_CNT=`ls -1 ${SNAP_BASE}/snapshot | wc -l`
if [ ${SNAPSHOT_CNT} -gt ${SNAPSHOT_MAXCNT} ]
then
  DELETE_CNT=`expr ${SNAPSHOT_CNT} - ${SNAPSHOT_MAXCNT}`
  ls -1 ${SNAP_BASE}/snapshot | head -n ${DELETE_CNT} | while read line ; do
    rm -rf ${SNAP_BASE}/snapshot/${line}
  done
fi

# -----------------------------------------------------------
# The end
exit 0
