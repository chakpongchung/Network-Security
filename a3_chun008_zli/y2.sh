rm M1 M2 :*: P1 P2

# 1.     Decrypt M2.base64 and read M2.
# echo -n ":C:->:Y:" > P2

base64 -d M2.base64 > M2
bash genPad.sh ":zli:->:cchun008:" M2

# M2 is overwritten by the following function
function fxorDecryptBase64 {
python - <<END
from encdec_wahab import *
fxorDecryptBase64_wahab('M2.pad','M2.base64','M2')
END
}
# Call it
fxorDecryptBase64

# 2.     Verify the signature  and Authenticate M2Sig.base64
openssl dgst -mac HMAC -macopt key:":zli:->:cchun008:" -md4 M2 | sed 's/^.*= //' > M2.hmac 
echo -n "`cat M2.hmac`" > M2.hmac
base64 -d M2Sig.base64 > M2Sig
openssl rsautl -verify -pubin  -inkey zliPublicKey.pem -out M2.hmac -in M2Sig

# # 3.     Edit a summary message M3 that have of at least 20 new byes
# # followed by the received plain message M2.
touch M3
echo -n "Dear cs772 grader:" > M3
echo "" >> M3
echo -n "I have successfuly communicated with zli" >> M3
echo "" >> M3
echo -n "here is the messages we exchanged." >> M3
echo "" >> M3
echo -n "Yours Chak-Pong" >> M3
echo "" >> M3
date >> M3
echo "" >> M3
echo "" >> M3
echo -n "---------------M2------------------" >> M3
echo "" >> M3
cat M2 >> M3

ls -lt M3
more M3

# # 4.     Use  the password  P3=“:Y:->:G:”  to  generate a onetime pad  to
# # encrypt M3  and save it  in  file: M3Enc.base64
# echo -n ":Y:->:G:" > P3
bash genPad.sh ":cchun008:->:cs772:" M3

function fxorEncryptBase64 {
python - <<END
from encdec_wahab import *
fxorEncryptBase64_wahab('M3.pad','M3','M3.base64')
END
}
# Call it
fxorEncryptBase64

# # 5.     Use HMAC to authenticate  M3  with P3.
# # Use Y’s  private key to sign the HMAC and  save it in a file: M3Sig.base64.
openssl dgst -mac HMAC -macopt key:":cchun008:->:cs772:" -md4 M3 | sed 's/^.*= //' > M3.hmac 
echo -n "`cat M3.hmac`" > M3.hmac
openssl rsautl -sign -inkey cchun008PrivateKey.pem -in M3.hmac | base64 > M3Sig.base64 

# # 6.  tar -cf Y_C.tar  README  M1.base64  M1Sig.base64    M2.base64  M2Sig.base64    M3.base64  M3Sig.base64
rm *.tar
tar -cf cchun008_zli.tar  README  M1.base64  M1Sig.base64   M2.base64  M2Sig.base64    M3.base64 M3Sig.base64 y1.sh c1.sh y2.sh encdec_wahab.py
# # 6.     Submit    Y_C.tar to cs772   under Assignment  #3.