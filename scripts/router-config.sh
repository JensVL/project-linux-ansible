#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

configure

# Fix for error "INIT: Id "TO" respawning too fast: disabled for 5 minutes"
delete system console device ttyS0

#
# Basic settings
#
set system host-name 'router'
#set service ssh port '22'

#
# IP settings
#

set service dhcp

set interfaces ethernet eth0 address dhcp
set interfaces ethernet eth0 description WAN
set interfaces ethernet eth1 address 192.0.2.254/24
set interfaces ethernet eth1 description DMZ
set interfaces ethernet eth2 address 172.16.255.254/16
set interfaces ethernet eth2 description internal

set system gateway-address 10.0.2.15

set service dhcp-server shared-network-name avalon authoritative enable
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 default-router 172.16.0.1
set service dhcp‐server shared‐network‐name avalon subnet 172.16.0.0/16 static‐mapping mac‐address ff:ff:ff:ff:ff:ff
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 static-mapping ip-address <address>

set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 lease 14400
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 start 172.16.128.1 stop 172.16.191.254

set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 lease 43200
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 start 172.16.0.2 stop 172.16.127.254

#
# Network Address Translation
#

set nat source rule 100 outbound-interface 'eth0'
set nat source rule 100 source address '192.0.2.0/24'
set nat source rule 100 translation address masquerade

set nat source rule 200 outbound-interface 'eth0'
set nat source rule 200 source address '172.16.0.0/16'
set nat source rule 200 translation address masquerade

set nat source rule 300 outbound-interface 'eth1'
set nat source rule 300 source address '172.16.0.0/16'
set nat source rule 300 translation address masquerade

#
# Time
#

set system time-zone Etc/GMT+1
set system ntp server 'be.pool.ntp.org'

#
# Domain Name Service
#

set service dns forwarding domain avalon.lan server 172.16.192.1
set service dns forwarding name-server 10.0.2.15
set service dns forwarding listen-on 'eth1'
set service dns forwarding listen-on 'eth2'

# Make configuration changes persistent
commit
save

# Fix permissions on configuration
sudo chown -R root:vyattacfg /opt/vyatta/config/active

# vim: set ft=sh
