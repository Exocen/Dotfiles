#!/bin/bash

if [ `id -u` -ne 0 ]; then
    echo "Must be run as root"
    exit 1
else
    if [ -z ${DELUGE_DL_PATH+x} ] ; then
        if [ -z "$1" ]; then
            DELUGE_DL_PATH="/docker-data/deluge/dl/"
        fi
    fi
fi

docker run -d --rm --log-driver=journald \
    --name=deluge \
    -e PUID=1000 \
    -e PGID=1000 \
    -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro \
    --network=container:gluetun \
    -v /docker-data/deluge/:/config \
    -v $DELUGE_DL_PATH:/downloads \
    lscr.io/linuxserver/deluge:latest && echo "deluge started."