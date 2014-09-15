#!/bin/sh


CLI_COMMAND=${1}
shift

case $CLI_COMMAND in
  "help" )       /opt/snap/cli/help ;;
  "restore" )    /opt/snap/cli/restore $* ;;
  "show" )       /opt/snap/cli/show $* ;;
  "snapshot" )   /opt/snap/cli/snapshot ;;
  "start" )      /opt/snap/cli/start $* ;;
  * )            /opt/snap/cli/help ;;
esac


