#! /bin/sh
if test $# -eq 0
then
  echo "usage ./decHmac.sh <login> <SID>"  
  echo "usage ./decHmac.sh wahab 3826101211"   
  exit 0;
fi
login=$1
SID=$2
Passwd=`./dh.py $login cs772`
echo ">> dh passwd betwen $login and cs772 is:"
echo "\t $Passwd"

echo "tar xf $login-$SID.tar"
tar xf $login-$SID.tar
echo ".. extracted"
echo "openssl  enc  -des3  -d -base64  -in  $1_Tar.base64  -out  $1.tar"
openssl  enc  -des3  -d -base64  -in  $1_Tar.base64  -out  $1.tar
echo ".. decrypted"
echo "openssl  dgst -out $1_Tar2.hmac -mac HMAC -macopt key:"$Passwd" -md4 $1.tar"
openssl  dgst -out $1_Tar2.hmac -mac HMAC -macopt key:"$Passwd" -md4 $1.tar
echo ".. HMACed"
if (diff $1_Tar.hmac $1_Tar2.hmac)
then
        echo  HMAC Verified OK
        echo "tar xf $1.tar"
        tar xf $1.tar
	echo ".. extracted"
else
        echo  HMAC Verification Failure
fi
rm $1_Tar2.hmac
