#!/bin/bash

if [ `id -u` -ne 0 ]; then
    echo "Must be run as root"
    exit 1
fi

docker run -d --rm \
    --name=transmission \
    -e PUID=1000 \
    -e PGID=1000 \
    -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro \
    --network=container:gluetun \
    -p 9091:9091 \
    -p 51413:51413 \
    -p 51413:51413/udp \
    -v /docker-data/transmission/config/:/config \
    -v /docker-data/transmission/dl/:/downloads \
    lscr.io/linuxserver/transmission:latest
