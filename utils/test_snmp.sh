#!/bin/bash
service snmpd status
yum install -y net-snmp-utils
#snmpwalk -v2c -c<COMMUNITY_STRING>  <Target_host_name> system
