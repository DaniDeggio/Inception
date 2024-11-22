#!/bin/bash

mkdir -p /etc/nginx/ssl # if not exist, create ssl directory

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/inception.key \
  -out /etc/nginx/ssl/inception.crt \
  -subj "/C=IT/ST=RM/L=RM/O=42/OU=42/CN=dde-giov.42.fr/UID=Inception42" # generate certificate

nginx -g 'daemon off;' # start nginx in foreground
