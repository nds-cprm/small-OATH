#!/bin/bash

LOG_FILE="server_access.log"

# Read the request headers line by line until an empty line (\r) is reached
while read -r line; do

    # Check for the end of HTTP headers
    [ -z "$line" ] && break

    # Strip carriage return
    line=$(echo "$line" | tr -d '\r')

    echo "> $line "

    # Extract the HTTP Method and Request Path if it's the first line
    if [[ "$line" =~ ^(GET|POST|PUT|DELETE|OPTIONS|HEAD) ]]; then
        METHOD=$(echo "$line" | awk '{print $1}')
        PATH_URL=$(echo "$line" | awk '{print $2}')
    fi
done

# Log to both stdout and file
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_ENTRY="$TIMESTAMP $SOCAT_PEERADDR:$SOCAT_PEERPORT $METHOD $PATH_URL"
echo "$LOG_ENTRY" | tee -a "$LOG_FILE"

# Send HTTP Response to the Client (via Socat)
echo -e "HTTP/1.1 200 OK"
echo -e "Content-Type: text/plain"
echo -e "Connection: close"
echo -e ""
echo -e "HTTPS Server running via Socat + Bash."

