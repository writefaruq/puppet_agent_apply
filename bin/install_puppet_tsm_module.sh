#!/bin/bash
echo "Installing  Puppet module: tsm -- Ensure that TSM server and nodename properties are set correctly in host node's yaml config file "
puppet apply --pluginsync -e 'include tsm'  --modulepath=/etc/puppet/modules --hiera_config=/etc/puppet/hiera.yaml --debug --verbose 
echo "Now run the dsmc command to enter TSM password"
