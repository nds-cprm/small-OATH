#!/bin/bash

LOG_FILE="server_access.log"
CONTENT_LENGTH=0
METHOD=""
PATH_URL=""

# 1. Read Request Headers
while read -r line; do
    # Strip carriage return (\r)
    line="${line//$'\r'/}"

    echo "line: $line"

    # End of headers reached on an empty line
    [[ -z "$line" ]] && break

    # Parse HTTP Method and Path
    if [[ "$line" =~ ^(GET|POST|PUT|DELETE) ]]; then
        METHOD=$(echo "$line" | awk '{print $1}')
        PATH_URL=$(echo "$line" | awk '{print $2}')
    fi

    # Extract Content-Length for POST payloads
    if [[ "$line" =~ ^[Cc]ontent-[Ll]ength: ]]; then
        CONTENT_LENGTH=$(echo "$line" | awk '{print $2}')
    fi
done

# 2. Read POST Body (if payload exists)
POST_DATA=""
if [ "$CONTENT_LENGTH" -gt 0 ] && [ "$METHOD" = "POST" ]; then
    # Read exactly $CONTENT_LENGTH bytes to avoid hanging
    read -N "$CONTENT_LENGTH" POST_DATA
fi

# 3. Log Details
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_ENTRY="[$TIMESTAMP] ${SOCAT_SOCKADDR}:${SOCAT_SOCKPORT} $METHOD $PATH_URL"

if [ -not -z "$POST_DATA" ]; then
    LOG_ENTRY="$LOG_ENTRY | Body: $POST_DATA"
fi

echo "$LOG_ENTRY" | tee -a "$LOG_FILE"

# 4. Send HTTP Response

echo -e "HTTP/1.1 200 OK\r"
echo -e "Content-Type: application/json\r"
echo -e "Connection: close\r"
echo -e "\r"

echo -e "{\"status\":\"success\",\"message\":\"GET received\"}\r"

# Send a JSON confirmation back to the client
#if [ "$METHOD" = "POST" ]; then
#    echo -e "{\"status\":\"success\",\"received_bytes\":$CONTENT_LENGTH}\r"
#else
#    echo -e "{\"status\":\"success\",\"message\":\"GET received\"}\r"
#fi


