mkdir friend_cert_request
cd friend_cert_request
scp -r cchun008@linux.cs.odu.edu:/home/cs772/public_html/PKI/shell_scripts/students/* .
# ./gencertreq friend #dont repeat this step easily
./printcertreq  friend
cp friend_certreq.pem ../cchun008_cert_request/