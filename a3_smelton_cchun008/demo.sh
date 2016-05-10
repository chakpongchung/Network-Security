#!/bin/bash
# @(#) Bash script demos difference between openssl rsautl and dgst signing
# Usage: $0 <name of file to sign> <private key file, without passphrase>

# 1. Make an ASN1 config file

cat >asn1.conf <<EOF
asn1 = SEQUENCE:digest_info_and_digest

[digest_info_and_digest]
dinfo = SEQUENCE:digest_info
digest = FORMAT:HEX,OCT:`openssl dgst -sha256 $1 |cut -f 2 -d ' '`

[digest_info]
algid = OID:2.16.840.1.101.3.4.2.1
params = NULL

EOF

# If you are wondering what the "algid = OID:2.16.840.1.101.3.4.2.1" is, it's
# the SHA256 OID, see http://oid-info.com/get/2.16.840.1.101.3.4.2.1

# 2. Make a DER encoded ASN1 structure that contains the hash and
# the hash type
openssl asn1parse -i -genconf asn1.conf -out $1.dgst.asn1

# 3. Make a signature file that contains both the ASN1 structure and
# its signature
openssl rsautl -sign -in $1.dgst.asn1 -inkey $2 -out $1.sig.rsa

# 4. Verify the signature that we just made and ouput the ASN structure
openssl rsautl -verify -in $1.sig.rsa -inkey $2 -out $1.dgst.asn1_v

# 5. Verify that the output from the signature matches the original
# ASN1 structure
diff $1.dgst.asn1 $1.dgst.asn1_v

# 6. Do the equivalent of steps 1-5 above in one "dgst" command
openssl dgst -sha256 -sign $2 -out $1.sig.rsa_dgst $1

# 7. Verify that the signature file produced from the rsautl and the dgst
# are identical
diff $1.sig.rsa $1.sig.rsa_dgst