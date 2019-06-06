#!/bin/bash
echo "Installing  Puppet module: iptables -- Ensure that iptables rules are adjusted if necessary"
puppet apply --pluginsync -e 'include iptables'  --modulepath=/etc/puppet/modules --hiera_config=/etc/puppet/hiera.yaml --debug --verbose 
