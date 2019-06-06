#!/bin/bash
echo "Usage: ./run_adjoin_cmd.sh  <short_host_name> <Your_elevated_AD_account>"
net ads join createupn="<INSERT_KRB_PRINCIPAL>" createcomputer="<INSERT_AD_OU>" -U  $2
