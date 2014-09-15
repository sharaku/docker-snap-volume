# VOLUME & Snapshot

FROM debian:7.6
MAINTAINER sharaku

# ############################################################################
# installation of rsync
RUN \
  apt-get update && \
  apt-get -y install rsync && \
  apt-get -y install cron

# ############################################################################
# Add action script & CLI
ADD cli /opt/snap/cli
ADD snap.sh /opt/snap.sh
ADD start.sh /opt/start.sh
ADD cli.sh /opt/cli.sh
RUN chmod -R 555 /opt/*

# ############################################################################
# The registered default
# Data directory			：data:/opt/data
# Snapshot directory		：/opt/.snap
# Snapshot Maximum number	：128
# Snapshot sampling time	：AM 03:00 every day
RUN mkdir /opt/data /opt/.snap && chmod 755 /opt/data /opt/.snap
ENV VOLUME_DATA data:/opt/data
ENV VOLUME_SNAP /opt/.snap
ENV SNAP_MAX 128
ENV SNAP_CRON 0 3 * * *
ENV SNAPSHOTCONF $VOLUME_SNAP/snapshot.conf

# exec user
USER root

# Execution path
ENTRYPOINT ["/opt/cli.sh"]
