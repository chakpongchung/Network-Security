echo "Copy all the shell scripts and files needed."
cd /home/cpchung/Dropbox/odu/cs772/a5/cchun008_cert_request
scp -r cchun008@linux.cs.odu.edu:/home/cs772/public_html/PKI/shell_scripts/securemail/* .


echo "Encrypted mail : to send/receive encrypted messages."
ls -lrth *_cert.pem
echo "Send:"   
# % sendencmail   <receiver>   <file>
# The sender should have:  <receiver>_cert.pem
# <file> is the message to be encrypted.
# This produce <file>.enc which is encrypted with a secret key.
# The secret key is encrypted with the public key in  <receiver>_cert.pem
./sendencmail cchun008 M1
mail chakpongchung@gmail.com < M1.enc
 
echo "Read:" 
# First read your mail and save the msg in <file> then use the following command:
# % readencmail   <receiver>   <file>
# The recipient should have:
# <receiver>_cert.pem> &  <receiver>_privatekey.pem
ls -lrth *_cert.pem
ls -lrth *_privatekey.pem
# This decrypt mail in  <file> using the supplied certificate and private key.
# First, the secret key is decrypted using <receiver>_privatekey.pem       
# Then <file> is decrypted with the  secret key.
./readencmail cchun008 M1.enc   #problem with decrytion



