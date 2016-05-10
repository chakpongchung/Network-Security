#!/bin/bash

rm M1* :*:

echo -n "hello my friend! this is from Chak Pong " > M1
echo "" >> M1

date >> M1
echo "" >> M1

# echo -n ':cchun008:->:smelton:' > P1
echo -n ':cchun008:->:pvargas:' > P1

bash genPad.sh P1 M1

function fxorEncryptBase64 {
python - <<END
from encdec import *
fxorEncryptBase64('M1.pad','M1','M1.base64')
END
}
# Call it
fxorEncryptBase64

rm M1 M1.pad
base64 -d M1.base64 > M1
bash genPad.sh P1 M1
cp M1 M1.beforeDecrypt

function fxorDecryptBase64 {
python - <<END
from encdec import *
fxorDecryptBase64('M1.pad','M1.base64','M1')
END
}
# Call it
fxorDecryptBase64

more M1