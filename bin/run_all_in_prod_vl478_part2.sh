#!/bin/bash
echo "Usage: ./run_all_in_prod_vl478_part2.sh <short_host_name>   <Your_elevated_AD_account>"
echo "Running all Puppet modules. Have you  created a  up-to-date Puppet node definition in /etc/puppet/hierada/node/`hostname -f`.yaml"
source ./install_multiple_puppet_modules.sh
source ./run_adjoin_cmd.sh $1 $2
source ./enable_tsm_client.sh
