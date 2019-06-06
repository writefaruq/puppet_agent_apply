#!/bin/bash
echo "Installing  Puppet module: snmp -- Ensure that SNMP community string is updated in host node's yaml file"
puppet apply --pluginsync -e 'include snmp'  --modulepath=/etc/puppet/modules --hiera_config=/etc/puppet/hiera.yaml --debug --verbose 
