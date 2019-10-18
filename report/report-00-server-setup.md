# Enterprise Linux Lab Report: 00-server-setup
- Student name: Jens Van Liefferinge
- Github repo: <https://github.com/HoGentTIN/elnx-1920-sme-JensVL>

Applying basic configuration to the pu001 server and testing it.

## Test plan

1. On the host system, go to the local working directory of the project repository
2. Execute `vagrant status`
    - There should be one VM, `pu001` with status `not created`. If the VM does exist, destroy it first with `vagrant destroy -f pu001`
3. Execute `vagrant up pu001`
    - The command should run without errors (exit status 0)
4. Log in on the server with `vagrant ssh pu001` and run the acceptance tests. They should succeed

    ```console
    [vagrant@pu001 test]$ sudo /vagrant/test/runbats.sh
    Running test /vagrant/test/common.bats
    ✓ EPEL repository should be available
    ✓ Bash-completion should have been installed
    ✓ bind-utils should have been installed
    ✓ Git should have been installed
    ✓ Nano should have been installed
    ✓ Tree should have been installed
    ✓ Vim-enhanced should have been installed
    ✓ Wget should have been installed
    ✓ Admin user bert should exist
    ✓ Custom /etc/motd should be installed

    10 tests, 0 failures
    ```

    Any tests for the LAMP stack may fail, but this is not part of the current assignment.

5. Log off from the server and ssh to the VM as described below. You should **not** get a password prompt.

    ```console
    $ ssh bert@192.0.2.50
    Welcome to pu001.localdomain.
    enp0s3     : 10.0.2.15         fe80::a00:27ff:fe5c:6428/64
    enp0s8     : 192.0.2.50        fe80::a00:27ff:fecd:aeed/64
    [bert@pu001 ~]$
    ```
## Procedure/Documentation

1. Downloaded the [bertvv Ansible base role](https://github.com/bertvv/ansible-role-rh-base) into /ansible/roles
2. Added role into [site.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/site.yml)
3. Edited IP in [vagrant-hosts.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/vagrant-hosts.yml) to `192.0.2.10`
4. CentOS box not updated to VirtualBox Guest Additions 6.12, gave shared folders error: tried to fix using command line
5. Rolled back VirtualBox version to 6.10
6. Skipped MOTD test and changed username to `jens`
7. Tested using `vagrant up pu001` -> works
8. Added variables into [ansible/group_vars/all.yml](https://github.com/oGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/all.yml)
9. `vagrant provision pu001` gives following result:

    ```console
    PLAY RECAP *********************************************************************
    pu001: 
    ok = 28; changed = 1; unreachable = 0; failed = 0; skipped = 13; rescued = 0; ignored = 0
    ```

10. SSH into the VM using `vagrant SSH pu001`
11. Ran the common.bats test script
12. All tests completed successfully
13. Closed SSH connection
14. SSH into VM from host machine using `$ ssh jens@192.0.2.10` -> works, no password prompt
15. Closed SSH connection
16. Complete test report

## Test report

1. Executed `vagrant status` in the project repository
    - One VM `pu001` with status `not created`
2. Executed `vagrant up pu001` without errors
3. Logged in on the server with `vagrant ssh pu001` and ran the acceptance tests using `sudo /vagrant/test/runbats.sh`. 

    Output: 

    ```console
    [vagrant@pu001 ~]$ sudo /vagrant/test/runbats.sh
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
    ```

    LAMP tests failed, but those are not part of this assignment.

4. Logged off from the server and used SSH to gain access to the VM from the host machine using `$ ssh jens@192.0.2.10`. No password was asked.

## Resources

### Installing guest additions on CentOS
https://unix.stackexchange.com/questions/18435/how-to-install-virtualbox-guest-additions-on-centos-via-command-line-only?fbclid=IwAR0Z1PVLgys_lJV7fpKvOrQY_JoYIwLVDOALNFBNe-XCT8L-9FZ8q-MTEBc

### bertvv Role Variables
https://github.com/bertvv/ansible-role-rh-base