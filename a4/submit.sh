

rm *.tar
# ·        Use Diffie-Hellman with  p = 104729  and g = 104723 to generate a shared secret  DHS  between you and cs772.
# File  RandomPrimes  contain  the  random secrets.
echo -n "`python dhT.py 104729 104723 104393`" > TA
# more TA
echo -n "`python dhT.py 104729 104723 104347`" > TB
# more TB
echo -n "`python dhS.py 104729 104393 "$(cat TB)" `" > DHS

# to verify the sharedSecret
# echo -n "`python dhS.py 104729 104347 "$(cat TA)" `" >> DHS

# ·        tar your files:  README and all relevant files of your solutions to  Q1 and Q2.
# in a file called <login>.tar  where  login is your unix login name.

tar -cf cchun008.tar README DHS q1 q1.ods q2 dhS.py dhT.py


# ·        Use DES to encrypt file <login>.tar  using  DHS  and save the result in <login>_Tar.base64
more DHS
openssl enc -des3  -e -salt -base64 -in cchun008.tar -out cchun008_Tar.base64

# ·        Use HMAC to authenticate  file <login>.tar  using DHS  and save the result in <login>_Tar.hmac
openssl dgst -out cchun008_Tar.hmac -mac HMAC -macopt key:"`cat DHS`" -md4 cchun008.tar

# ·        tar  cf <login>-SID.tar  <login>_Tar.base64  <login>_Tar.hmac
tar  cf cchun008-3373742645.tar  cchun008_Tar.base64  cchun008_Tar.hmac
# ·        Submit    <login>-SID.tar    to  cs772   under Assignment  #4.
# ·        To test your submission:
# cd  /home/cs772/public_html/fall15/assignments/a4/gradingScripts 
# and follow the instructions in README_grade



