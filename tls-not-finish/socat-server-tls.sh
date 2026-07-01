#!/bin/bash
#
# uses socat to create HTTPS web server running on local port
#
# blog: https://fabianlee.org/2022/10/26/linux-socat-used-as-secure-https-web-server/
#
#       agsb@2026, changes comments and to call a bash script
#

set -x

# define domain
FQDN="${1:-mysocat.local}"

# define port
PORT="${2:-9443}"

# verify socat

[ -x `which socat` ] || sudo apt install socat -y

[ -x `which openssl` ] || sudo apt install openssl -y

# verify SSL

[ -f $FQDN.key ] || openssl genrsa -out $FQDN.key 2048
[ -f $FQDN.crt ] || openssl req -new -key $FQDN.key -x509 -days 3653 -out $FQDN.crt -subj "/C=US/ST=CA/L=SFO/O=myorg/CN=$FQDN"
[ -f $FQDN.pem ] || cat $FQDN.key $FQDN.crt >$FQDN.pem && \
chmod 600 $FQDN.key $FQDN.pem && chmod 644 $FQDN.crt

# a plain HTTP server

socat -4 -ls TCP-LISTEN:${PORT},reuseaddr,fork SYSTEM:./server.sh,stderr

# a secure HTTPS server

#socat -4 -ls OPENSSL-LISTEN:${PORT},cert=${FQDN}.pem,verify=0,reuseaddr,fork,\
#crlf,pktinfo \
#SYSTEM:./server.sh,stderr

# or say hello

#SYSTEM:"echo HTTP/1.0 200; echo Content-Type\: text/plain; echo; echo \"hello from $(hostname) at \$(date)\""

