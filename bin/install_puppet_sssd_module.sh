#!/bin/bash
echo "Installing  Puppet module: sssd -- Ensure that all hostname parameters are updated in host node's yaml file"
puppet apply --pluginsync -e 'include sssd'  --modulepath=/etc/puppet/modules --hiera_config=/etc/puppet/hiera.yaml --debug --verbose 
echo "Now run the appropriate AD join command"
