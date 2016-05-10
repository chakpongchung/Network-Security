# Part 1

# mkdir cchun008_cert_request
# cd cchun008_cert_request
cd /home/cpchung/Dropbox/odu/cs772/a5/cchun008_cert_request
scp -r cchun008@linux.cs.odu.edu:/home/cs772/public_html/PKI/shell_scripts/students/* .

# # ./gencertreq cchun008 #dont repeat this step easily
# openssl req -in cchun008_certreq.pem -text -noout
echo "./printcertreq  cchun008"
./printcertreq  cchun008

#  For Self  Service Signing:
 
# Instead of the traditional procedure of submitting the request and the CA to sign it, do the following:
 
# % cd /home/cs772/public_html/fall15/PKI_certificates/issue_certificates
# % issuecert <your login>
 
# This will sign your certificate and sends an email  to you to copy:
 
#       <student>_cert.pem  &  ca_cert.pem
 
# Then you can print these two certificates using:


# download the cert.pem
cd /home/cpchung/Dropbox/odu/cs772/a5/cchun008_cert_request
scp -r cchun008@linux.cs.odu.edu:/home/cs772/public_html/fall15/PKI_certificates/students/*_cert.pem .
echo "print these two certificates using openssl:"
openssl x509 -in cchun008_cert.pem -text -noout
openssl x509 -in ca_cert.pem -text -noout


# scp -r cchun008@linux.cs.odu.edu:/home/cs772/public_html/PKI/shell_scripts/ca/* . #dont repeat this step easily

# ./printcertreq  cchun008
# not working, permission denied
# cp /home/cs772/public_html/PKI/shell_scripts/ca_selfservice/* .

# Part 2
cd /home/cpchung/Dropbox/odu/cs772/a5/cchun008_cert_request
echo "scp -r cchun008@linux.cs.odu.edu:/home/cs772/public_html/PKI/shell_scripts/securemail/* ."
scp -r cchun008@linux.cs.odu.edu:/home/cs772/public_html/PKI/shell_scripts/securemail/* .
echo -n "hello my friend! this is from Chak" > M1
echo "" >> M1

date >> M1
echo "" >> M1