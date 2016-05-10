



rm cchun008* Password* Signature* Solution* *.cipher
# 1.
openssl genrsa -out cchun008PrivateKey.pem -des3 1024
openssl rsa -in cchun008PrivateKey.pem -pubout -out cchun008PublicKey.pem
# 2.
more pwd
openssl rsautl -encrypt -pubin -inkey cs772PublicKey.pem -in pwd -out pwd.cipher
openssl enc -base64 -e -out Password.base64 -in pwd.cipher
# 3.
tar cf Solution.tar ./*
# 4.
openssl enc -des3 -e -salt -base64 -in Solution.tar -out Solution.base64
# 5.
openssl dgst -sha1 -sign cchun008PrivateKey.pem -out Signature Solution.base64
openssl enc -base64 -e -out Signature.base64 -in Signature
# 6.
tar cf cchun008.tar cchun008PublicKey.pem Password.base64 Solution.base64 Signature.base64
