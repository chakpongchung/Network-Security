#! /bin/sh
if test $# -eq 0
then
  echo "usage ./grade.sh <login> <SID>"  
  echo "usage ./grade.sh wahab 3826101211"   
  exit 0;
fi
./decHmac.sh  $1 $2
./checkSID.sh $1 $2
