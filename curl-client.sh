#!/bin/bash
#
# uses curl to test socat HTTPS web server
#
# blog: https://fabianlee.org/2022/10/26/linux-socat-used-as-secure-https-web-server/
#
#       agsb@2026, changes comments and to call a bash script
#

#echo all
set -e

PASS_FILE="./pass.lst"

# define domain
FQDN="${1:-localhost}"

# define port
PORT="${2:-4433}"

# define namespace

# pretend a event

EVENT="`shuf -i 0-12 -n 1`"

SERVICE="beat"

SERVER="`shuf -i 1-6 -n 1`"

SERVER="host${SERVER}"

MESSAGE="status"

TIMES="`date --iso-8601=seconds`"

MYPASS="`grep $SERVER $PASS_FILE | cut -d':' -f 2`"

OATH="`oathtool --totp=SHA256 -b ${MYPASS}`"

NAMESPACE="/${EVENT}/${SERVICE}/${SERVER}/${MESSAGE}/${TIMES}/${OATH}/"

echo "namespace: ${NAMESPACE}"

# use a plain server

# do a GET with namespace

curl -4 -v --http0.9 http://${FQDN}:${PORT}/${NAMESPACE}/

