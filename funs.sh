#!/usr/bin/bash

set -e

# global variables

        PASS_FILE="./pass.lst"

# depended variables

        NO_USER="`tail -1 *.log | cut -d'/' -f 5 | tr '/' ' '`"
        NO_DATE="`tail -1 *.log | cut -d'/' -f 7 `"
        NO_CODE="`tail -1 *.log | cut -d'/' -f 8 `"
        NO_PASS="`grep "${NO_USER}" ${PASS_FILE} | cut -d':' -f 2`"

# echo "${NO_USER}, ${NO_DATE}, ${NO_CODE}"

IT_CODE="`oathtool --totp=SHA256 -b ${NO_PASS} -N ${NO_DATE} `"

echo "${NO_CODE} is ${IT_CODE}"

