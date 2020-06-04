# Enterprise Linux Lab Report

- Student name: Jens Van Liefferinge
- Github repo: <https://github.com/HoGentTIN/elnx-1920-sme-JensVL>

Integrate the built environment using a DHCP server.

## Test plan

1. On the host system, go to the local working directory of the project repository.
2. Execute `vagrant plugin install vagrant-vyos` followed by `vagrant status`.
3. The VMs with the name `pu001`,`pr001`, `router` and `pr011` should be running. If they don't, run `vagrant up pu001 pr001 router pr011`.
4. Download the Fedora Workstation .iso from [this link](https://getfedora.org/en/workstation/download/).
5. Open VirtualBox and click on `New`.
6. Give the VM a name and select `Linux > Fedora 64bit` as OS.
7. Leave other settings on default. When prompted to make a VHD, leave it on 8GB and continue the wizard.
8. Go to Tools.
9. Add a new Host-Only adapter with ip `172.16.192.15` and subnetmask `255.25.0.0`.
10. Go into the settings of the VM.
11. Attach the new host-only adapter.
12. Boot.
13. After booting, open the network settings.
14. Manually set ipv4 with following settings:

```console
IP: 172.16.192.15
Netmask: 255.255.0.0
Gateway: 172.16.0.1
DNS: 172.16.192.1,172.16.192.2
```

15. Open a terminal window and execute following commands, they should succeed:

- `ping 192.0.2.10`
- `ping 172.16.192.1`
- `ping 172.16.192.11`

16. In the workstation file browser, go to `smb://files/`.
17. Enter a folder.
18. Login with `jens - AVALON - jens`
19. Try to enter management: should be locked.
20. Try to make a file into technical: should be locked.
21. Enter IT and make a folder. Should work.
22. Open Firefox and browse to `https://192.0.2.10`. Apache page should be visible.

## Procedure/Documentation

1. Installed `vagrant-vytos` plugin
2. Booted VM to test -> works
3. Added NTP configuration into [router config](https://github.com/JensVL/project-linux-ansible/tree/solution/scripts/router-config.sh):

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

8. Added DHCP config into [router config](https://github.com/JensVL/project-linux-ansible/tree/solution/scripts/router-config.sh):

```shell
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 default-router 172.16.0.1

set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 dns-server 172.16.192.1
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 dns-server 172.16.192.2

set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 lease 14400
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 start 172.16.128.1 stop 172.16.191.254

set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 lease 43200
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 start 172.16.0.2 stop 172.16.127.254

set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 static-mapping test1 ip-address 172.16.128.10
set service dhcp‐server shared‐network‐name avalon subnet 172.16.0.0/16 static‐mapping test1 mac‐address DE:AD:C0:DE:CA:FE

set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 static-mapping test2 ip-address 172.16.128.11
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 static-mapping test2 mac-address DE:AD:C0:DE:CA:FF
```

9. Booted router:

```console
router:
    router:   Nothing to delete (the specified node does not exist)
    router:
    router:   Configuration path: [interfaces ethernet eth0 address dhcp] already exists
    router:
    router:   Configuration path: [interfaces ethernet eth1 address 192.0.2.254/24] already exists
    router:
    router:   Configuration path: [interfaces ethernet eth2 address 172.16.255.254/16] already exists
    router:
    router:   Configuration path: service [dhcp‐server] is not valid
    router:   Set failed
    router: [ system host-name router ]
    router: Stopping enhanced syslogd: rsyslogd
    router: .
    router: Starting enhanced syslogd: rsyslogd
    router: .
    router:
    router: [ system time-zone Etc/GMT+1 ]
    router: Stopping enhanced syslogd: rsyslogd
    router: .
    router: Starting enhanced syslogd: rsyslogd
    router: .
    router:
    router: [ system ntp ]
    router: Stopping NTP server: ntpd
    router: .
    router: Starting NTP server: ntpd
    router: .
    router:
    router: [ service dhcp-server ]
    router: No static DHCP lease mac address specified for static mapping 'test1'
    router: under shared network name 'avalon'.
    router: DHCP server configuration commit aborted due to error(s).
    router:
    router: [[service dhcp-server]] failed
    router: Commit failed
    router: Warning: you have uncommitted changes that will not be saved.
    router: Saving configuration to '/config/config.boot'...
    router: Done
```

10. Tried to work with ranges:

```console
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 lease 14400
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 range 2 start 172.16.128.1
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 range 2 stop 172.16.191.254

set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 lease 43200
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 range 1 start 172.16.0.2
set service dhcp-server shared-network-name avalon subnet 172.16.0.0/16 range 1 stop 172.16.127.254
```

11. Ranges not supported
12. Reverted back to first config
13. Tried to fix MAC assignment using:

```console
set system static-host-mapping host-name test1.avalon inet '172.16.128.10'
```

14. No effect on result
15. Commented first lease
16. No effect on result
17. ssh into pu001

- ping 172.16.192.15 - OK
- ping 172.16.192.11 - OK
- ping 172.16.0.1 - OK
- ping 10.0.2.15 - OK

18. ssh into router

- ping 192.0.2.10 - OK
- ping 172.16.192.15 - doesnt work
- ping 172.16.192.11 - doesnt work

19. ssh into pr001

- ping 172.16.192.15 - OK
- ping 172.16.192.11 - OK
- ping 172.16.0.1 - doesnt work
- ping 10.0.2.15 - OK

20. Opened workstation terminal

- ping 192.0.2.10 - doesnt work
- ping 172.16.192.1 - OK
- ping 172.16.192.11 - OK
- ping 172.16.0.1 - doesnt work
- ping 10.0.2.15 - doesnt work

## Test report

1. Plugin already installed.
2. Launched VMs.
3. Made a new VM.
9. Added a new Host-Only adapter with ip `172.16.192.15` and subnetmask `255.25.0.0`.
10. Attached the host-only adapter.
11. Booted and set ipv4 settings.
12. Entered pings:

- `ping 192.0.2.10` - doesn't work
- `ping 172.16.192.1` -  OK
- `ping 172.16.192.11` -  OK

13. Went to `smb://files/`.
14. Entered a folder. Logged in.
15. Tried to enter management: locked.
16. Tried to make a file into technical: locked.
17. Entered IT and made a folder. Worked.
18. Opened Firefox and browsed to `https://192.0.2.10`. Connection timed out.

## Resources

- <https://wiki.vyos.net/wiki/Main_Page>
- <http://eugene.taranov.me/2017/02/12/vyos-configuration/>
- <https://github.com/bertvv/cheat-sheets/blob/master/docs/VyOS.md>
- <https://docs.vyos.io/en/latest/services/dhcp.html>
