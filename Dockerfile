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
# Add action script
ADD snap.sh /opt/snap.sh
ADD start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh /opt/snap.sh

# ############################################################################
# The registered default
# Data directory			：/opt/data
# Snapshot directory		：/opt/.snap
# Snapshot Maximum number	：128
# Snapshot sampling time	：AM 03:00 every day
RUN mkdir /opt/data /opt/.snap && chmod 755 /opt/data /opt/.snap
ENV VOLUME_DATA /opt/data
ENV VOLUME_SNAP /opt/.snap
ENV SNAP_MAX 128
ENV SNAP_CRON 0 3 * * *

# exec user
USER root

# Execution path
ENTRYPOINT /opt/start.sh
