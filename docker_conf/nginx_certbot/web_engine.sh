#!/bin/bash

mkdir -p /var/log/nginx /var/log/letsencrypt
cp -fr /root/nginx-confs/fifo-nginx.conf /etc/nginx/nginx.conf

if ! /usr/bin/certbot certificates | grep '[DOMAIN]\|*.[DOMAIN]' &>/dev/null; then
    echo "Invalid certificate :"
    /usr/bin/certbot certificates
    echo "Creating new certificates :"
    /usr/bin/certbot --nginx --keep-until-expiring --expand --register-unsafely-without-email --agree-tos -q -d [DOMAIN] -d git.[DOMAIN] -d mail.[DOMAIN] -d status.[DOMAIN] -d www.[DOMAIN] -d vw.[DOMAIN]
    if ! /usr/bin/certbot certificates | grep '[DOMAIN]\|*.[DOMAIN]' &>/dev/null; then
        echo "certbot failed exiting..."
        exit 1
    fi
fi

[ ! -f /etc/letsencrypt/live/[DOMAIN]/dhparam.pem ] && openssl dhparam -out /etc/letsencrypt/live/[DOMAIN]/dhparam.pem 4096

cp -fr /root/nginx-confs/*.conf /etc/nginx/
pkill 'nginx'
nginx -g 'daemon off;'
