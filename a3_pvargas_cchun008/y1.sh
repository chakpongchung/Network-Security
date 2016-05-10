#! /bin/sh
rm M1 :*: P1
# Y1:

# 1.     Edit a message M1 of at least 20 bytes to send C
echo -n "hello my friend! this is from Chak Pong " > M1
echo "" >> M1

date >> M1
echo "" >> M1

ls -lt M1
more M1
# 2. Use the password  P1=“:Y:->:C:” to generate a onetime pad to
# encrypt  M1 and save it  in  file: M1.base64
# echo -n ":Y:->:C:" > P1
bash genPad.sh ":cchun008:->:zli:" M1


function fxorEncryptBase64 {
python - <<END
from encdec_wahab import *
fxorEncryptBase64_wahab('M1.pad','M1','M1.base64')
END
}
# Call it
fxorEncryptBase64

# 3. Use HMAC to authenticate M1  with P1.
# Use Y’s  private key to sign the HMAC and  save it in a file: M1Sig.base64.
openssl dgst -mac HMAC -macopt key:":cchun008:->:zli:" -md4 M1 | sed 's/^.*= //' > M1.hmac 
echo -n "`cat M1.hmac`" > M1.hmac
openssl rsautl -sign -inkey cchun008PrivateKey.pem -in M1.hmac | base64 > M1Sig.base64 

# 4. Email  C  the two files  M1.base64 & M1Sig.base64.

