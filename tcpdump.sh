#!/bin/sh

if [ -z $TCPDUMP_ENABLE ]; then
    echo "Set TCPDUMP_ENABLE to enable packet capture."
    sleep 1d
    exit 0
fi

if [ -z $TCPDUMP_DIR ]; then
    TCPDUMP_DIR=/home/packages
fi

if [ -z $CTF_PORT ]; then
    CTF_PORT=1337
fi

mkdir -p $TCPDUMP_DIR
echo "TCPDUMP: capture port: $CTF_PORT, split time interval: 10mins"
exec /usr/sbin/tcpdump -i eth0 dst port $CTF_PORT -G 60 -w $TCPDUMP_DIR/%Y_%m%d_%H%M_%S.pcap 