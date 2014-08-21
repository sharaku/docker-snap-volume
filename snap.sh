#!/bin/sh
# usage:
#  snap.sh {data dir} {snap dir} {snap max}
DATADIR=${1}
SNAP_BASE=${2}
SNAPSHOT_MAXCNT=${3}

# -----------------------------------------------------------
# I want to back up to SNAP_BASE data DATADIR
# Backup format is as follows
# ${SNAP_BASE}/@GMT-2014.08.01-03.00.00
SNAP_HEAD=`ls -1 ${SNAP_BASE} | tail -n 1`
SNAP_DIR='@GMT-'`TZ=GMT date +%Y.%m.%d-%H.%M.%S`
rsync -a --delete --link-dest="${SNAP_BASE}/${SNAP_HEAD}" ${DATADIR} ${SNAP_BASE}/${SNAP_DIR}

# -----------------------------------------------------------
# I want to delete old ones Snapshot of the number of generations or more
SNAPSHOT_CNT=`ls -1 ${SNAP_BASE} | wc -l`
if [ ${SNAPSHOT_CNT} -gt ${SNAPSHOT_MAXCNT} ]
then
  SNAP_OLD=`ls -1 ${SNAP_BASE} | head -n 1`
  rm -rf ${SNAP_BASE}/${SNAP_OLD}
fi

# -----------------------------------------------------------
# The end
exit 0
