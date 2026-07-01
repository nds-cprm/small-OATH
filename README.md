# Small OTP

__THIS FILE IS A STUB__

This is a small how to about oathtool  

## install programs

sudo apt update && sudo apt install oathtool qrencode jq

## process

1. generate a unique key and convert o base 32:

uuid | base32 > .mypass

2. share the unique key


3. generate a on time password with time control:

oathtool -v --totp=SHA256 -b ` cat .mypass ` > otp

4. select the line with "Current Time:"

cat otp | grep "Current" | cut -d' ' -f 3-5 > lst

3. confirm on time password

oathtool -v --totp=SHA256 -b "`cat .mypass`" -N "`cat lst`"

## QR code

To view at terminal:

qrencode -t ANSI256 -o otp_qr.png "otpauth://totp/YourAccountName?secret=YOUR_SECRET_KEY&issuer=YourIssuer"

To generate a png:

qrencode -o otp_qr.png "otpauth://totp/YourAccountName?secret=YOUR_SECRET_KEY&issuer=YourIssuer"

## LUKS

https://michaelwaterman.nl/2025/10/14/secure-luks-container-on-linux/


