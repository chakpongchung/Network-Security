#!/bin/sh
if test $# -eq 0
then
  echo "usage ./checkSID.sh <login> <SID>"  
  echo "usage ./checkSID.sh wahab 3826101211"   
  exit 0;
fi

login=$1
SID=$2
set `egrep $login ./RandomPrimes`
p=$2
q=$3
computed=`./DivMod.py $SID $p  $q`
echo $login computed ODU ID: $computed
