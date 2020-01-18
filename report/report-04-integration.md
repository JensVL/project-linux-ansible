# Enterprise Linux Lab Report

- Student name: Jens Van Liefferinge
- Github repo: <https://github.com/HoGentTIN/elnx-1920-sme-JensVL>

Integrate the built environment using a DHCP server.

## Test plan

## Procedure/Documentation

1. Installed `vagrant-vytos` plugin
2. Booted VM to test -> works
3. Added NTP configuration into [router config](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/scripts/router-config.sh):

```shell
set system time-zone Etc/GMT+1
set system ntp server 'be.pool.ntp.org'
```

4. Added basic interface config:

```shell
set interfaces ethernet eth0 address dhcp
set interfaces ethernet eth0 description WAN
set interfaces ethernet eth1 address 192.0.2.254/24
set interfaces ethernet eth1 description DMZ
set interfaces ethernet eth2 address 172.16.255.254/16
set interfaces ethernet eth2 description internal

set system gateway-address 10.0.2.15
```

5. Added DNS config:

```shell
set service dns forwarding domain avalon.lan server 172.16.192.1
set service dns forwarding name-server 10.0.2.15
set service dns forwarding listen-on 'eth1'
set service dns forwarding listen-on 'eth2'
```

6. Added NAT config:

```shell
set nat source rule 100 outbound-interface 'eth0'
set nat source rule 100 source address '192.0.2.0/24'
set nat source rule 100 translation address masquerade

set nat source rule 200 outbound-interface 'eth0'
set nat source rule 200 source address '172.16.0.0/16'
set nat source rule 200 translation address masquerade

set nat source rule 300 outbound-interface 'eth1'
set nat source rule 300 source address '172.16.0.0/16'
set nat source rule 300 translation address masquerade
```

7. Added DHCP basics:

```shell
set service dhcp
set service dhcp-server shared-network-name avalon authoritative enable
```

## Test report

## Resources

- <https://wiki.vyos.net/wiki/Main_Page>
- <http://eugene.taranov.me/2017/02/12/vyos-configuration/>
- <https://github.com/bertvv/cheat-sheets/blob/master/docs/VyOS.md>
- <https://docs.vyos.io/en/latest/services/dhcp.html>
