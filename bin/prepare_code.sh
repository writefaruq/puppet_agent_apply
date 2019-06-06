#!/bin/bash
echo  "Usage: ./prepare_puppet_agent.sh "
mv /etc/puppet /tmp
cd /root/src/puppet_agent_apply  && cp -R src/etc/puppet /etc
mv /etc/hiera.yaml /tmp && ln -s /etc/puppet/hiera.yaml /etc/hiera.yaml
cd /etc/puppet/modules/vmwaretools/ &&  tar -zxf files/VMwareTools-8.6.12.28992.tar.gz


