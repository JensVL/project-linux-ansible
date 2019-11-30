# Enterprise Linux Lab Report

- Student name: Jens Van Liefferinge
- Github repo: <https://github.com/HoGentTIN/elnx-1920-sme-JensVL>

Setting up a master and slave DNS server for the `avalon.lan` domain.

## Test plan

1. On the host system, go to the local working directory of the project repository.
2. Execute `vagrant status`.
3. The VMs with the names `pr001` and `pr002` should not exist. If the VMs do exist, destroy them first with `vagrant destroy -f pr001` and `vagrant destroy -f pr002`.
4. Execute `vagrant up pr001 pr002` to launch both DNS servers.
    - The command should run without errors (exit status 0)
5. Log in on the master DNS server with `vagrant ssh pr001` and run the acceptance tests using `sudo /vagrant/test/runbats.sh`. They should succeed:

```console
Running test /vagrant/test/common.bats
 ✓ SELinux should be set to 'Enforcing'
 ✓ Firewall should be enabled and running
 ✓ EPEL repository should be available
 ✓ Bash-completion should have been installed
 ✓ bind-utils should have been installed
 ✓ Git should have been installed
 ✓ Nano should have been installed
 ✓ Tree should have been installed
 ✓ Vim-enhanced should have been installed
 ✓ Wget should have been installed
 ✓ Admin user jens should exist
 ✓ An SSH key should have been installed for jens
 - Custom /etc/motd should have been installed (skipped)

13 tests, 0 failures, 1 skipped
Running test /vagrant/test/pr001/masterdns.bats
 ✓ The dig command should be installed
 ✓ The main config file should be syntactically correct
 ✓ The forward zone file should be syntactically correct
 ✓ The reverse zone files should be syntactically correct
 ✓ The service should be running
 ✓ Forward lookups public servers
 ✓ Forward lookups private servers
 ✓ Reverse lookups public servers
 ✓ Reverse lookups private servers
 ✓ Alias lookups public servers
 ✓ Alias lookups private servers
 ✓ NS record lookup
 ✓ Mail server lookup

13 tests, 0 failures
```

6. Exit out of the SSH session using `exit`.
7. Log in on the slave DNS server with `vagrant ssh pr002` and run the acceptance tests using `sudo /vagrant/test/runbats.sh`. They should succeed:

```console
Running test /vagrant/test/common.bats
 ✓ SELinux should be set to 'Enforcing'
 ✓ Firewall should be enabled and running
 ✓ EPEL repository should be available
 ✓ Bash-completion should have been installed
 ✓ bind-utils should have been installed
 ✓ Git should have been installed
 ✓ Nano should have been installed
 ✓ Tree should have been installed
 ✓ Vim-enhanced should have been installed
 ✓ Wget should have been installed
 ✓ Admin user jens should exist
 ✓ An SSH key should have been installed for jens
 - Custom /etc/motd should have been installed (skipped)

13 tests, 0 failures, 1 skipped
Running test /vagrant/test/pr002/slavedns.bats
 ✓ The dig command should be installed
 ✓ The main config file should be syntactically correct
 ✓ The server should be set up as a slave
 ✓ The server should forward requests to the master server
 ✓ There should not be a forward zone file
 ✓ The service should be running
 ✓ Forward lookups public servers
 ✓ Forward lookups private servers
 ✓ Reverse lookups public servers
 ✓ Reverse lookups private servers
 ✓ Alias lookups public servers
 ✓ Alias lookups private servers
 ✓ NS record lookup
 ✓ Mail server lookup

14 tests, 0 failures
```

8. Verify Fail2ban is running by executing the following command: `systemctl status fail2ban`. Status should be active (running).

## Procedure/Documentation

1. Downloaded the [bertvv bind](https://github.com/bertvv/ansible-role-bind) into /ansible/roles
2. Added roles into [site.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/site.yml)
3. Added `dns1` group into `group_vars`
4. Added primary dns configuration variables into [dns1.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/dns1.yml)
5. Launched `pr001`
6. Ran the acceptance tests:

```console
Running test /vagrant/test/common.bats
 ✓ SELinux should be set to 'Enforcing'
 ✓ Firewall should be enabled and running
 ✓ EPEL repository should be available
 ✓ Bash-completion should have been installed
 ✓ bind-utils should have been installed
 ✓ Git should have been installed
 ✓ Nano should have been installed
 ✓ Tree should have been installed
 ✓ Vim-enhanced should have been installed
 ✓ Wget should have been installed
 ✓ Admin user jens should exist
 ✓ An SSH key should have been installed for jens
 - Custom /etc/motd should have been installed (skipped)

13 tests, 0 failures, 1 skipped
Running test /vagrant/test/pr001/masterdns.bats
 ✓ The dig command should be installed
 ✓ The main config file should be syntactically correct
 ✓ The forward zone file should be syntactically correct
 ✓ The reverse zone files should be syntactically correct
 ✓ The service should be running
 ✓ Forward lookups public servers
 ✓ Forward lookups private servers
 ✓ Reverse lookups public servers
 ✓ Reverse lookups private servers
 ✓ Alias lookups public servers
 ✓ Alias lookups private servers
 ✓ NS record lookup
 ✓ Mail server lookup

13 tests, 0 failures
```

7. Added `dns2` group into `group_vars`
8. Added slave dns configuration variables into [dns2.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/dns2.yml)
9. Launched `pr002`
10. Ran the acceptance tests:

```console
Running test /vagrant/test/common.bats
 ✓ SELinux should be set to 'Enforcing'
 ✓ Firewall should be enabled and running
 ✓ EPEL repository should be available
 ✓ Bash-completion should have been installed
 ✓ bind-utils should have been installed
 ✓ Git should have been installed
 ✓ Nano should have been installed
 ✓ Tree should have been installed
 ✓ Vim-enhanced should have been installed
 ✓ Wget should have been installed
 ✓ Admin user jens should exist
 ✓ An SSH key should have been installed for jens
 - Custom /etc/motd should have been installed (skipped)

13 tests, 0 failures, 1 skipped
Running test /vagrant/test/pr002/slavedns.bats
 ✓ The dig command should be installed
 ✓ The main config file should be syntactically correct
 ✓ The server should be set up as a slave
 ✓ The server should forward requests to the master server
 ✓ There should not be a forward zone file
 ✓ The service should be running
 ✗ Forward lookups public servers
   (from function `assert_forward_lookup' in file /vagrant/test/pr002/slavedns.bats, line 18,
    in test file /vagrant/test/pr002/slavedns.bats, line 106)
     `assert_forward_lookup pu001      192.0.2.10' failed
 ✗ Forward lookups private servers
   (from function `assert_forward_lookup' in file /vagrant/test/pr002/slavedns.bats, line 18,
    in test file /vagrant/test/pr002/slavedns.bats, line 112)
     `assert_forward_lookup pr001      172.16.192.1' failed
 ✗ Reverse lookups public servers
   (from function `assert_reverse_lookup' in file /vagrant/test/pr002/slavedns.bats, line 28,
    in test file /vagrant/test/pr002/slavedns.bats, line 122)
     `assert_reverse_lookup pu001      192.0.2.10' failed
 ✗ Reverse lookups private servers
   (from function `assert_reverse_lookup' in file /vagrant/test/pr002/slavedns.bats, line 28,
    in test file /vagrant/test/pr002/slavedns.bats, line 128)
     `assert_reverse_lookup pr001      172.16.192.1' failed
 ✗ Alias lookups public servers
   (from function `assert_alias_lookup' in file /vagrant/test/pr002/slavedns.bats, line 40,
    in test file /vagrant/test/pr002/slavedns.bats, line 138)
     `assert_alias_lookup www        pu001      192.0.2.10' failed
 ✗ Alias lookups private servers
   (from function `assert_alias_lookup' in file /vagrant/test/pr002/slavedns.bats, line 40,
    in test file /vagrant/test/pr002/slavedns.bats, line 144)
     `assert_alias_lookup ns1        pr001      172.16.192.1' failed
 ✗ NS record lookup
   (from function `assert_ns_lookup' in file /vagrant/test/pr002/slavedns.bats, line 50,
    in test file /vagrant/test/pr002/slavedns.bats, line 153)
     `assert_ns_lookup pr001 pr002' failed
 ✗ Mail server lookup
   (from function `assert_mx_lookup' in file /vagrant/test/pr002/slavedns.bats, line 64,
    in test file /vagrant/test/pr002/slavedns.bats, line 157)
     `assert_mx_lookup 10 pu002' failed

14 tests, 8 failures
```

11. Added `networks` into slave dns configuration as per [commit](https://github.com/bertvv/ansible-role-bind/commit/1df9f2c409335fbe0c07ad4997c27d656a9e3061)
12. Tests still failing
13. Double checked syntax, copied configuration from [example](https://github.com/bertvv/ansible-role-bind)
14. Tests still failing
15. Added `bind_forwarders` into slave configuration
16. Tests still failing
17. Added [Fail2Ban](https://github.com/hwwilliams/ansible-role-fail2ban) role
18. Configured Fail2ban in [all.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/all.yml)
19. Added Fail2Ban role to every server
20. Commented Fail2ban because it takes a long time to provision
21. Ran testing environment from [test branch](https://github.com/bertvv/ansible-role-bind/tree/vagrant-tests) to check config
22. Merge DNS configuration into one file
23. Tests still failing
24. Added `53/udp` & `53/tcp` ports to firewall
25. Remake VMs
26. Ran tests on pr002:

```console
Running test /vagrant/test/common.bats
 ✓ SELinux should be set to 'Enforcing'
 ✓ Firewall should be enabled and running
 ✓ EPEL repository should be available
 ✓ Bash-completion should have been installed
 ✓ bind-utils should have been installed
 ✓ Git should have been installed
 ✓ Nano should have been installed
 ✓ Tree should have been installed
 ✓ Vim-enhanced should have been installed
 ✓ Wget should have been installed
 ✓ Admin user jens should exist
 ✓ An SSH key should have been installed for jens
 - Custom /etc/motd should have been installed (skipped)

13 tests, 0 failures, 1 skipped
Running test /vagrant/test/pr002/slavedns.bats
 ✓ The dig command should be installed
 ✓ The main config file should be syntactically correct
 ✓ The server should be set up as a slave
 ✓ The server should forward requests to the master server
 ✓ There should not be a forward zone file
 ✓ The service should be running
 ✓ Forward lookups public servers
 ✓ Forward lookups private servers
 ✓ Reverse lookups public servers
 ✓ Reverse lookups private servers
 ✓ Alias lookups public servers
 ✓ Alias lookups private servers
 ✓ NS record lookup
 ✓ Mail server lookup

14 tests, 0 failures
```

27. Split up master & slave configuration again for clarity
28. Verify tests are still passing -> OK
29. Uncommented Fail2ban
30. Verified Fail2ban is working by:
    - Checking status: `systemctl status fail2ban` -> running
    - Checking IP tables: `sudo iptables -L f2b-sshd`
31. Wrote test plan
32. Wrote test report

## Test report

1. Destroyed VMs.
2. Executed `vagrant up pr001 pr002`.
    - The command ran without errors (exit status 0).
3. Logged in on the master DNS server with `vagrant ssh pr001` and ran the acceptance tests using `sudo /vagrant/test/runbats.sh`. They succeeded:

```console
Running test /vagrant/test/common.bats
 ✓ SELinux should be set to 'Enforcing'
 ✓ Firewall should be enabled and running
 ✓ EPEL repository should be available
 ✓ Bash-completion should have been installed
 ✓ bind-utils should have been installed
 ✓ Git should have been installed
 ✓ Nano should have been installed
 ✓ Tree should have been installed
 ✓ Vim-enhanced should have been installed
 ✓ Wget should have been installed
 ✓ Admin user jens should exist
 ✓ An SSH key should have been installed for jens
 - Custom /etc/motd should have been installed (skipped)

13 tests, 0 failures, 1 skipped
Running test /vagrant/test/pr001/masterdns.bats
 ✓ The dig command should be installed
 ✓ The main config file should be syntactically correct
 ✓ The forward zone file should be syntactically correct
 ✓ The reverse zone files should be syntactically correct
 ✓ The service should be running
 ✓ Forward lookups public servers
 ✓ Forward lookups private servers
 ✓ Reverse lookups public servers
 ✓ Reverse lookups private servers
 ✓ Alias lookups public servers
 ✓ Alias lookups private servers
 ✓ NS record lookup
 ✓ Mail server lookup

13 tests, 0 failures
```

4. Exited out of the SSH session using `exit`.
5. Logged in on the slave DNS server with `vagrant ssh pr002` and ran the acceptance tests using `sudo /vagrant/test/runbats.sh`. They succeeded:

```console
Running test /vagrant/test/common.bats
 ✓ SELinux should be set to 'Enforcing'
 ✓ Firewall should be enabled and running
 ✓ EPEL repository should be available
 ✓ Bash-completion should have been installed
 ✓ bind-utils should have been installed
 ✓ Git should have been installed
 ✓ Nano should have been installed
 ✓ Tree should have been installed
 ✓ Vim-enhanced should have been installed
 ✓ Wget should have been installed
 ✓ Admin user jens should exist
 ✓ An SSH key should have been installed for jens
 - Custom /etc/motd should have been installed (skipped)

13 tests, 0 failures, 1 skipped
Running test /vagrant/test/pr002/slavedns.bats
 ✓ The dig command should be installed
 ✓ The main config file should be syntactically correct
 ✓ The server should be set up as a slave
 ✓ The server should forward requests to the master server
 ✓ There should not be a forward zone file
 ✓ The service should be running
 ✓ Forward lookups public servers
 ✓ Forward lookups private servers
 ✓ Reverse lookups public servers
 ✓ Reverse lookups private servers
 ✓ Alias lookups public servers
 ✓ Alias lookups private servers
 ✓ NS record lookup
 ✓ Mail server lookup

14 tests, 0 failures
```

6. Verified Fail2ban is running by executing `systemctl status fail2ban`. Output below:

```console
[vagrant@pr002 ~]$ systemctl status fail2ban
● fail2ban.service - Fail2Ban Service
   Loaded: loaded (/usr/lib/systemd/system/fail2ban.service; enabled; vendor preset: disabled)
   Active: active (running) since Sat 2019-11-30 16:35:55 UTC; 14min ago
     Docs: man:fail2ban(1)
  Process: 6888 ExecStop=/usr/bin/fail2ban-client stop (code=exited, status=0/SUCCESS)
  Process: 6919 ExecStart=/usr/bin/fail2ban-client -x start (code=exited, status=0/SUCCESS)
 Main PID: 6922 (fail2ban-server)
   CGroup: /system.slice/fail2ban.service
           └─6922 /usr/bin/python2 -s /usr/bin/fail2ban-server -s /var/run/fail2ban/fail2ban.sock -p /var/run/fail2ba...
```

## Resources

### bertvv Role Variables

- <https://github.com/bertvv/ansible-role-bind>
- <https://github.com/bertvv/ansible-role-bind/blob/docker-tests/test.yml>

### DNS server

- <https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-centos-7>
- <https://likegeeks.com/linux-dns-server>
- <https://hogenttin.github.io/elnx-syllabus/bind/#/useful-commands>

### Fail2Ban

- <https://github.com/melvin-suter/ansible.fail2ban>
- <https://github.com/hwwilliams/ansible-role-fail2ban>
