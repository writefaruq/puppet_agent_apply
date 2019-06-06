#!/bin/bash
echo "Installing  Puppet module: vmwaretools"
puppet apply --pluginsync -e 'include vmwaretools'  --modulepath=/etc/puppet/modules --hiera_config=/etc/puppet/hiera.yaml --debug --verbose 
