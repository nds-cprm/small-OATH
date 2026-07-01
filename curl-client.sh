#!/bin/bash
#
# uses curl to test socat HTTPS web server
#
# blog: https://fabianlee.org/2022/10/26/linux-socat-used-as-secure-https-web-server/
#

set -x

FQDN="${1:-localhost}"
PORT="${2:-4433}"

# do a GET with namespace

EVENT="${3:-4}"
SERVICE="${4:-beat}"
SERVER="${5:-localhost}"
MESSAGE="${6:-status}"
TIMES="`date --iso-8601=seconds`"

echo "namespace: ${EVENT}/${SERVICE}/${SERVER}/${MESSAGE}/${TIMES}/"

# use a plain server

curl -4 -v http://${FQDN}:${PORT}/${EVENT}/${SERVICE}/${SERVER}/${MESSAGE}/${TIMES}/

