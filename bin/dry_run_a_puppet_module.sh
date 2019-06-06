#!/bin/bash
echo "Dry running -- Install  Puppet module $1"
echo " Usage: ./install_a_puppet_module.sh  <Name of the module>  "
echo "Available modules: ntp, rhn_register, vmwaretools, iptables, snmp, sssd, tsm"
puppet apply --pluginsync -e 'include $1'  --modulepath=/etc/puppet/modules --hiera_config=/etc/puppet/hiera.yaml --debug --verbose --noop
