#!/usr/bin/bash

set -e

NOWIS="`tail -1 *.log | cut -d'/' -f 7`"

oathtool --totp=SHA256 -b "`cat .mypass`" -N "${NOWIS}"

