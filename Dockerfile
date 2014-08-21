# VOLUME & Snapshot

FROM debian:7.6
MAINTAINER sharaku

# ############################################################################
# rsyncのインストール
RUN \
  apt-get update && \
  apt-get -y install rsync && \
  apt-get -y install cron

# ############################################################################
# 動作スクリプトを追加
ADD snap.sh /opt/snap.sh
ADD start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh /opt/snap.sh

# ############################################################################
# デフォルトを登録
# データディレクトリ	：/opt/data
# Snapshotディレクトリ	：/opt/.snap
# Snapshot最大世代数	：128
# Snapshot採取時間		：毎日 AM 03:00
RUN mkdir /opt/data /opt/.snap && chmod 755 /opt/data /opt/.snap
ENV VOLUME_DATA /opt/data
ENV VOLUME_SNAP /opt/.snap
ENV SNAP_MAX 128
ENV SNAP_CRON 0 3 * * *

# exec user
USER root

# 実行パス
ENTRYPOINT /opt/start.sh
