#!/bin/bash

#defaults
DIR=".ssl";
defaultperiod=365;
keysize=4096;

#read credentials
echo 'type in the name of your private key:'
read keyname;

#create folderstructure if necessary
if [ ! -d ~/${DIR} ]; 
then  
  # Take action if $DIR exists. #
  echo "Installing config files in ${DIR}..."
  mkdir ~/${DIR};
fi


if [ ! -d ~/$DIR/private/ ]; then
  mkdir ~/${DIR}/private/;
fi


if [ ! -d ~/$DIR/public/ ]; then
  mkdir ~/${DIR}/public/;
fi


#ask for validationtime of ssl-certificate
echo 'Validity period in days:'
read period;

if [[ $period ]] && [ $period -eq $period 2>/dev/null ]
then  echo "ssl-certificate will expire in $period days."
else  echo "Input wasn't guilty. Time till certificate will expire is set up to $defaultperiod days" && period=$defaultperiod;
fi

sleep 2

if [ -s ~/${DIR}/private/${keyname}.key ]
then keyname=${keyname}_copy;
fi

sudo openssl genrsa -out ~/${DIR}/private/${keyname}.key $keysize
sudo openssl req -new -key ~/${DIR}/private/${keyname}.key -out ~/${DIR}/public/${keyname}.csr
sudo openssl x509 -req -days $period -in ~/${DIR}/public/${keyname}.csr -signkey ~/${DIR}/private/${keyname}.key -out ~/${DIR}/public/${keyname}.crt

