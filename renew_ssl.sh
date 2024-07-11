#!/bin/bash

echo "backup old certificate"

mv /var/lib/3cxpbx/Bin/nginx/conf/Instance1/sip1.govoiponline.ca-crt.pem /var/lib/3cxpbx/Bin/nginx/conf/Instance1/sip1.govoiponline.ca-crt.pembk

mv /var/lib/3cxpbx/Bin/nginx/conf/Instance1/sip1.govoiponline.ca-key.pem /var/lib/3cxpbx/Bin/nginx/conf/Instance1/sip1.govoiponline.ca-key.pembk

mv /var/lib/3cxpbx/Bin/nginx/conf/Instance1/fullchain.pem /var/lib/3cxpbx/Bin/nginx/conf/Instance1/fullchain.pembk
 
cd /etc/letsencrypt/archive/sip1.govoiponline.ca/
echo " find the new certificate files"

privkey=$(find . -type f -name "priv*" -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-)
cert=$(find . -type f -name "cert*" -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-)
chain=$(find . -type f -name "fullchain*" -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-)

echo "copy new certificate file to the ssl path"

cp /etc/letsencrypt/archive/sip1.govoiponline.ca/$privkey /var/lib/3cxpbx/Bin/nginx/conf/Instance1/sip1.govoiponline.ca-key.pem 

#cp /etc/letsencrypt/archive/sip1.govoiponline.ca/$cert /var/lib/3cxpbx/Bin/nginx/conf/Instance1/sip1.govoiponline.ca-crt.pem 

cp /etc/letsencrypt/archive/sip1.govoiponline.ca/$chain /var/lib/3cxpbx/Bin/nginx/conf/Instance1/fullchain.pem 

echo " change owner of certificate to 3cx"

cd /var/lib/3cxpbx/Bin/nginx/conf/Instance1/

cat ~/root.pem >> /var/lib/3cxpbx/Bin/nginx/conf/Instance1/fullchain.pem 

cp fullchain.pem sip1.govoiponline.ca-crt.pem

chown phonesystem:phonesystem sip1.govoiponline.ca-crt.pem

chown phonesystem:phonesystem sip1.govoiponline.ca-key.pem

chown phonesystem:phonesystem fullchain.pem


service nginx restart
