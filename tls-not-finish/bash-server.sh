#!/bin/bash

# Configuration
PORT=4433
LOG_FILE="server_access.log"
CERT="cert.pem"
KEY="key.pem"

echo "HTTPS Server running on https://localhost:$PORT"
echo "Logging requests to $LOG_FILE..."

# Persistent response loop
while true; do
    # OpenSSL handles the TLS handshake, pipes incoming data into Bash
    # Bash reads the request, generates logs, and passes back an HTTP string
    openssl s_server -accept $PORT -cert "$CERT" -key "$KEY" -quiet 2>/dev/null | while true; do

        # Read the HTTP Request line (e.g., "GET /index.html HTTP/1.1")
        read -r request_line

        # Break if the request line is empty (client disconnected)
        [[ -z "$request_line" ]] && break

        # Parse individual components from request
        read -r method path protocol << "$request_line"

        # Log the timestamp and request details to file
        timestamp=$(date "+[%d/%b/%Y:%H:%M:%S %z]")
        echo "127.0.0.1 - - $timestamp \"$method $path $protocol\" 200" >> "$LOG_FILE"

        # Send a standard HTTP/1.1 response body back to the client
        printf "HTTP/1.1 200 OK\r\n"
        printf "Content-Type: text/plain\r\n"
        printf "Connection: close\r\n\r\n"
        printf "Hello from your Bash HTTPS Server!\n"
        printf "Logged request path: %s\n" "$path"

        break
    done
done

