#!/bin/sh

nsjail --config /etc/nsjail.cfg -d

# # for kill and restart
nohup socat TCP-LISTEN:9999,fork,bind=localhost  EXEC:/rerun.sh 2>> /tmp/rerun.log & 

