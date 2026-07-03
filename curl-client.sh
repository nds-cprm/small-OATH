#!/bin/bash
#
# uses curl to test socat HTTPS web server
#
# blog: https://fabianlee.org/2022/10/26/linux-socat-used-as-secure-https-web-server/
#
#       agsb@2026, changes comments and to call a bash script
#

#echo all
set -x

# define domain
FQDN="${1:-localhost}"

# define port
PORT="${2:-4433}"

#define namespace

EVENT="${3:-4}"
SERVICE="${4:-beat}"
SERVER="${5:-localhost}"
MESSAGE="${6:-status}"
TIMES="`date --iso-8601=seconds`"
MYPASS="`cat .mypass`"
OATH="`oathtool --totp=SHA256 -b ${MYPASS}`"

NAMESPACE="/${EVENT}/${SERVICE}/${SERVER}/${MESSAGE}/${TIMES}/${OATH}/"

echo "namespace: ${NAMESPACE}"

# use a plain server

# do a GET with namespace

curl -4 -v --http0.9 http://${FQDN}:${PORT}/${NAMESPACE}/

