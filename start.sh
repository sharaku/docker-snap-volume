#!/bin/sh

# 以下の環境変数により、制御を変える
# ENV VOLUME_DATA /opt/data
# ENV VOLUME_SNAP /opt/.snap
# ENV SNAP_MAX 128
# ENV SNAP_CRON 0 3 * * *

# 指定された環境変数を元にcrontabを設定
# 指定する引数は環境変数を元にする
echo "${SNAP_CRON} root /opt/snap.sh ${VOLUME_DATA} ${VOLUME_SNAP} ${SNAP_MAX}" >> /etc/crontab

# cronの起動
# プロセスID等は保存の必要がないため、起動するのみ
cron

# プロセスを殺さないようにする
exec tail -f /dev/null

