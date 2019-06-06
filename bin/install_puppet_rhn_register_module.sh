#!/bin/bash
echo "Installing  Puppet module: rhn_register -- Ensure that you place the activation key in the host node's yaml file"
puppet apply --pluginsync -e 'include rhn_register'  --modulepath=/etc/puppet/modules --hiera_config=/etc/puppet/hiera.yaml --debug --verbose 
