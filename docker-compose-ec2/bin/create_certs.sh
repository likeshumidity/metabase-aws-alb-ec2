#!/bin/bash
# Create self-signed certificate

echo "Usage:"
echo "  # Use default LOCAL_DOMAIN 'metabase.localtest'"
echo "  $ ./bin/create_certs.sh"
echo "  # Specify a LOCAL_DOMAIN 'metabase.localtest'"
echo "  $ ./bin/create_certs.sh LOCAL_DOMAIN"
echo ".."
echo "  Replace LOCAL_DOMAIN with your local domain"
echo "  Run from the docker-compose-local/ directory."
echo "  LOCAL_DOMAIN cannot contain localhost and must contain at least"
echo "    one . and subdomain like metabase.localtest."
echo ".."
echo ".."

# Load arguments
if [ ${1:-"##NOVALUE##"} = "##NOVALUE##" ]
then
  LOCAL_DOMAIN=metabase.localtest
else
  LOCAL_DOMAIN=$1
fi

echo "LOCAL_DOMAIN set to: $LOCAL_DOMAIN"


# Check for config file
if ! [ -f config/openssl-req.conf ]
then
  echo "EXITING, no 'config/openssl-req.conf' found."
  exit 1
fi

echo "Create and enter the certs/ folder."
mkdir certs
cd certs

echo "Create a private key in the certs/ folder."
openssl genrsa -out $LOCAL_DOMAIN.key 2048

echo "Create a Certificate Signing Request \(CSR\) in the certs/ folder."
openssl req -config ../config/openssl-req.conf -key $LOCAL_DOMAIN.key -new -out $LOCAL_DOMAIN.csr

echo "Create a self-signed certificate in the certs/ folder."
openssl x509 -signkey $LOCAL_DOMAIN.key -in $LOCAL_DOMAIN.csr -req -days 365 -out $LOCAL_DOMAIN.crt

echo "Convert PEM to DER in the certs/ folder."
openssl x509 -in $LOCAL_DOMAIN.crt -outform der -out $LOCAL_DOMAIN.der





