#!/bin/bash
echo  "Usage: ./download_code.sh <Your_USER_ID>"
yum install -y git 
cd && mkdir src && cd src && git clone https://$1@<repo>.git


