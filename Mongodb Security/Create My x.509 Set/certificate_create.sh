#!/bin/bash

set -x
set -e

# basic variables
#dn_prefix="/C=CA/ST=QC/L=Montreal/O=MongoDB Home"
dn_prefix="/C=CA"
ou_member="MyServers"
ou_client="MyClients"
mongodb_server_hosts=( "server1" "server2" "server3" )
mongodb_client_hosts=( "client1" "client2" )
#mongodb_port=27017
#root_ca_config="/home/vagrant/shared/root-ca.cfg"
root_ca_config="/home/vagrant/shared/certificate_sign/root-ca.cfg"
host_name=`hostname -f`

# create local root CA
openssl genrsa -out root-ca.key 2048
#openssl req -new -x509 -days 3650 -key root-ca.key -out root-ca.crt -subj "$dn_prefix/CN=$host_name"
openssl req -new -x509 -days 3650 -key root-ca.key -out root-ca.crt -subj "$dn_prefix/CN=$host_name"

mkdir -p RootCA/ca.db.certs
echo "01" >> RootCA/ca.db.serial
touch RootCA/ca.db.index
echo $RANDOM >> RootCA/ca.db.rand
mv root-ca* RootCA/
cat RootCA/root-ca.key RootCA/root-ca.crt > RootCA/root-ca.pem

cat >> root-ca.cfg <<EOF
[ RootCA ]
dir             = ./RootCA
certs           = \$dir/ca.db.certs
database        = \$dir/ca.db.index
new_certs_dir   = \$dir/ca.db.certs
certificate     = \$dir/root-ca.crt
serial          = \$dir/ca.db.serial
private_key     = \$dir/root-ca.key
RANDFILE        = \$dir/ca.db.rand
default_md      = sha256
default_days    = 365
default_crl_days= 30
email_in_dn     = no
unique_subject  = no
policy          = policy_match

[ SigningCA ]
dir             = ./SigningCA
certs           = \$dir/ca.db.certs
database        = \$dir/ca.db.index
new_certs_dir   = \$dir/ca.db.certs
certificate     = \$dir/signing-ca.crt
serial          = \$dir/ca.db.serial
private_key     = \$dir/signing-ca.key
RANDFILE        = \$dir/ca.db.rand
default_md      = sha256
default_days    = 365
default_crl_days= 30
email_in_dn     = no
unique_subject  = no
policy          = policy_match

[ policy_match ]
countryName     = match
#stateOrProvinceName = match
#localityName            = match
#organizationName    = match
organizationalUnitName  = optional
commonName      = supplied
emailAddress        = optional

[ req ]
default_bits		= 2048
#default_keyfile 	= privkey.pem
#distinguished_name	= req_distinguished_name
#attributes		= req_attributes
x509_extensions	= v3_ca	# The extensions to add to the self signed cert
req_extensions = v3_req 	# The extensions to add to a certificate request

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = database.m310.mongodb.university
DNS.2 = infrastructure.m310.mongodb.university
DNS.3 = database

[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer:always
basicConstraints = CA:true
EOF

# generate the signing key
openssl genrsa -out signing-ca.key 2048
# openssl genrsa -aes256 -out signing-ca.key 2048

openssl req -new -days 1460 -key signing-ca.key -out signing-ca.csr -subj "$dn_prefix/CN=$host_name"
#openssl ca -batch -name RootCA -config $root_ca_config -extensions v3_ca -out signing-ca.crt -infiles signing-ca.csr 
openssl ca -batch -notext -name RootCA -config $root_ca_config -keyfile /home/vagrant/shared/certificate_sign/RootCA/root-ca.key -out signing-ca.crt -infiles signing-ca.csr 

mkdir -p SigningCA/ca.db.certs
echo "01" >> SigningCA/ca.db.serial
touch SigningCA/ca.db.index
echo $RANDOM >> SigningCA/ca.db.rand
mv signing-ca* SigningCA/
cat SigningCA/signing-ca.key SigningCA/signing-ca.crt > SigningCA/signing-ca.pem
cat SigningCA/signing-ca.crt RootCA/root-ca.crt > ca-chain.pem

# Create root-ca.pem
#cat RootCA/root-ca.key SigningCA/signing-ca.crt > root-ca.pem

# create server certificate
for host in "${mongodb_server_hosts[@]}"; do
    echo "Generating key for $host"
    openssl genrsa  -out ${host}.key 2048
    openssl req -new -days 365 -key ${host}.key -out ${host}.csr -subj "$dn_prefix/OU=$ou_member/CN=$host_name"
    openssl ca -batch -notext -name SigningCA -config $root_ca_config -keyfile /home/vagrant/shared/certificate_sign/SigningCA/signing-ca.key -out ${host}.crt -infiles ${host}.csr
    cat ${host}.key ${host}.crt > ${host}.pem   
done 

# create client certificate
#for host in "${mongodb_client_hosts[@]}"; do
#    echo "Generating key for $host"
#    openssl genrsa  -out ${host}.key 2048
#    openssl req -new -days 365 -key ${host}.key -out ${host}.csr -subj "$dn_prefix/OU=$ou_client/CN=$host_name"
#    openssl ca -batch -notext -name SigningCA -config $root_ca_config -keyfile /home/vagrant/shared/certificate_sign/SigningCA/signing-ca.key -out ${host}.crt -infiles ${host}.csr
#    cat ${host}.key ${host}.crt > ${host}.pem   
#done

openssl genrsa  -out client1.key 2048
openssl req -new -days 365 -key client1.key -out client1.csr -subj "$dn_prefix/OU=$ou_client/CN=client1"
openssl ca -batch -notext -name SigningCA -config $root_ca_config -keyfile /home/vagrant/shared/certificate_sign/SigningCA/signing-ca.key -out client1.crt -infiles client1.csr
cat client1.key client1.crt > client1.pem

openssl genrsa  -out client2.key 2048
openssl req -new -days 365 -key client2.key -out client2.csr -subj "$dn_prefix/OU=$ou_client/CN=client2"
openssl ca -batch -notext -name SigningCA -config $root_ca_config -keyfile /home/vagrant/shared/certificate_sign/SigningCA/signing-ca.key -out client2.crt -infiles client2.csr
cat client2.key client2.crt > client2.pem
































