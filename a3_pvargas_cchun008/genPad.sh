#! /bin/sh
if test $# -eq 0
then
  echo "usage genPad.sh <passwdString> <plainFile/cipherFile>"
  exit 0;
fi

touch PasswdFile
echo -n "$1" > PasswdFile

PadFile=$2.pad
rm -f $PadFile
touch $PadFile

filesize=`cat $2 | wc -c`
#echo file size: $filesize

nblocks=`expr $filesize / 16 + 1 `
#echo number of 16-byte blocks: $nblocks

cat PasswdFile > nextblock
i=1
while test $i -le $nblocks  
do
   #echo "Block $i "
   cat nextblock |  openssl   dgst  -binary  -md4  > PadBlock  
   cat PadBlock >> $PadFile
   cat PasswdFile > nextblock
   cat PadBlock >> nextblock
   i=`expr $i + 1`
done
#echo done generating $PadFile
rm nextblock PadBlock PasswdFile
