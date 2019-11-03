# Enterprise Linux Lab Report

- Student name: Jens Van Liefferinge
- Github repo: <https://github.com/HoGentTIN/elnx-1920-sme-JensVL>

Setting up a master and slave DNS server for the `avalon.lan` domain.

## Test plan

1. On the host system, go to the local working directory of the project repository
2. Execute `vagrant status`
3. The VMs with the names `pr001` and `pr002` should not exist. If the VMs do exist, destroy them first with `vagrant destroy -f pr001` and `vagrant destroy -f pr002`.
2. Execute `vagrant up pr001` to launch the primary DNS server.
    - The command should run without errors (exit status 0)
3. Log in on the server with `vagrant ssh pr001` and run the acceptance tests using `sudo /vagrant/test/runbats.sh`. They should succeed:
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
4. Exit out of the SSH session using `exit`.
5. Launch the secondary DNS server using `vagrant up pr002`.

## Procedure/Documentation


## Test report


## Resources

### bertvv Role Variables
- https://github.com/bertvv/ansible-role-bind
- https://github.com/bertvv/ansible-role-bind/blob/docker-tests/test.yml