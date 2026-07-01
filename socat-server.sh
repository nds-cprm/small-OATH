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
FQDN="${1:-localhost}"

# define port
PORT="${2:-4433}"

# a plain HTTP server

socat -4 -ls TCP-LISTEN:${PORT},reuseaddr,fork,crlf SYSTEM:./server.sh,stderr

