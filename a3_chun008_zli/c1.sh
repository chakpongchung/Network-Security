#! /bin/sh
# C1:
rm M2 M1 :*: P1 P2
# 1.     Decrypt M.base64 and read M1.
# echo -n ":Y:->:C:" > P1
rm M1 M1.pad

base64 -d M1.base64 > M1
bash genPad.sh ":cchun008:->:zli:" M1
# M1 is overwritten by the following function
function fxorDecryptBase64 {
python - <<END
from encdec_wahab import *
fxorDecryptBase64_wahab('M1.pad','M1.base64','M1')
END
}
# Call it
fxorDecryptBase64

more M1

# 2.     Verify the signature  and Authenticate M1Sig.base64 

openssl dgst -mac HMAC -macopt key:":cchun008:->:zli:" -md4 M1 | sed 's/^.*= //' > M1.hmac 
echo -n "`cat M1.hmac`" > M1.hmac

base64 -d M1Sig.base64 > M1Sig

openssl rsautl -verify -pubin  -inkey cchun008PublicKey.pem -in M1Sig -out  M1.hmac

# 3.     Edit a reply M2 that have of at least 20 new byes followed by the received plain message M1.
cp M1 M2
echo -n "Hello Chak Pong, this is a reply from your friend" >> M2
echo "" >> M2

date >> M2
echo "" >> M2

ls -lt M2
more M2

# 4.     Use  the password P2= “:C:->:Y:”  to  generate a onetime pad to
# eencrypt M2  and save it  in  file: M2.base64
# echo -n ":C:->:Y:" > P2
bash genPad.sh ":zli:->:cchun008:" M2

function fxorEncryptBase64 {
python - <<END
from encdec_wahab import *
fxorEncryptBase64_wahab('M2.pad','M2','M2.base64')
END
}
# Call it
fxorEncryptBase64

# 5.     Use HMAC to authenticate M2  with P2.
# Use C’s  private key to sign the HMAC and  save it in a file: M2Sig.base64.
openssl dgst -mac HMAC -macopt key:":zli:->:cchun008:" -md4 M2 | sed 's/^.*= //' > M2.hmac 
echo -n "`cat M2.hmac`" > M2.hmac
openssl rsautl -sign -inkey cchun008PrivateKey.pem -in M1.hmac | base64 > M1Sig.base64 
# 6.     Email  Y  the two files  M2.base64 & M2Sig.base64.