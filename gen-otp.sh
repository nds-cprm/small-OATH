#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# Dependencies check
for cmd in qrencode oathtool; do
    if [ which "$cmd" &> /dev/null] ; then
        echo "Error: Required command '$cmd' is not installed." >&2
        exit 1
    fi
done

# Help menu
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -s, --secret   Your Base32 2FA secret key (Required)"
    echo "  -a, --account  Account identity or email (Default: user@example.com)"
    echo "  -i, --issuer   Service provider name (Default: Google)"
    echo "  -h, --help     Display this help message"
}

# Default values
ACCOUNT="user@example.com"
ISSUER="Google"
SECRET=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--secret) SECRET="${2//[[:space:]]/}"; shift 2 ;; # Strip spaces
        -a|--account) ACCOUNT="$2"; shift 2 ;;
        -i|--issuer) ISSUER="$2"; shift 2 ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown option: $1"; show_help; exit 1 ;;
    esac
done

# Validate secret
if [[ -z "$SECRET" ]]; then
    echo "Error: Secret key (-s) is required." >&2
    show_help
    exit 1
fi

# URL encode variables for safety
URL_ACCOUNT=$(jq -nr --arg str "$ACCOUNT" '$str | @uri')
URL_ISSUER=$(jq -nr --arg str "$ISSUER" '$str | @uri')
URL_SECRET=$(jq -nr --arg str "$SECRET" '$str | @uri')

# Construct Google Authenticator compatible URI
OTP_URI="otpauth://totp/${URL_ISSUER}:${URL_ACCOUNT}?secret=${URL_SECRET}&issuer=${URL_ISSUER}"

# Output results safely
echo -e "\n=== CURRENT ACTIVE OTP CODE ==="
oathtool --totp --base32 "$SECRET" 2>/dev/null || echo "Invalid secret format for oathtool."
echo -e "================================\n"

echo "Scan this QR Code with Google Authenticator:"
qrencode -t ANSI256 "$OTP_URI"

