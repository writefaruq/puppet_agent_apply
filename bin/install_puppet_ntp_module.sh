#!/bin/bash
echo "Installing  Puppet module: ntp -- Ensure ntpservers are adjusted in the host node definition file"
puppet apply --pluginsync -e 'include ntp'  --modulepath=/etc/puppet/modules --hiera_config=/etc/puppet/hiera.yaml --debug --verbose 
