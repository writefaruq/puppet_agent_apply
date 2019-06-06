#!/bin/bash
echo  "Usage: ./install_puppet_agent.sh <Your_USER_ID>"
rhn-channel --add --channel=puppetlabs --channel=<sat_channel>   -u  $1
yum repolist
yum install puppet -y

