# Enterprise Linux Lab Report: 01-lamp
- Student name: Jens Van Liefferinge
- Github repo: <https://github.com/HoGentTIN/elnx-1920-sme-JensVL>

Installing & configuring a LAMP stack on pu001.

## Test plan

1. On the host system, go to the local working directory of the project repository
2. Execute `vagrant status`
    - There should be one VM, `pu001` with status `not created`. If the VM does exist, destroy it first with `vagrant destroy -f pu001`
3. Execute `vagrant up pu001`
    - The command should run without errors (exit status 0)
4. Log in on the server with `vagrant ssh pu001` and run the acceptance tests. They should succeed

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
    Running test /vagrant/test/pu001/lamp.bats
    ✓ The necessary packages should be installed
    ✓ The Apache service should be running
    ✓ The Apache service should be started at boot
    ✓ The MariaDB service should be running
    ✓ The MariaDB service should be started at boot
    ✓ The SELinux status should be ‘enforcing’
    ✓ Web traffic should pass through the firewall
    ✓ Mariadb should have a database for Wordpress
    ✓ The MariaDB user should have write
    ✓ The website should be accessible through HTTP
    ✓ The website should be accessible through HTTPS
    ✓ The certificate should not be the default one
    ✓ The Wordpress install page should be visible under http://192.0.2.10/wordpress/
    ✓ MariaDB should not have a test database
    ✓ MariaDB should not have anonymous users

    15 tests, 0 failures
    ```

5. On the host sytem, browse to `192.0.2.10`
6. An Apache welcome page should be visible
7. On the host system, browse to `192.0.2.10/wordpress`
8. A wordpress install page should be visible



## Procedure/Documentation

1. Downloaded the [bertvv httpd](https://github.com/bertvv/ansible-role-httpd) into /ansible/roles
2. Downloaded the [bertvv mariadb](https://github.com/bertvv/ansible-role-mariadb) into /ansible/roles
3. Downloaded the [bertvv wordpress](https://github.com/bertvv/ansible-role-wordpress) into /ansible/roles
4. Added roles into [site.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/site.yml)
5. Added `pu` group into `group_vars`
6. Added configuration variables into [pu.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/pu.yml)
7. Edited variables in test scripts
8. `vagrant provision pu001`
9. `vagrant ssh pu001`
10. Created SSL certificate using [CentOS wiki](https://wiki.centos.org/HowTos/Https)
11. Moved certificate to /ansible/files
12. Added SSL variable configuration into [pu.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/pu.yml)
13. `vagrant provision`
14. `vagrant ssh pu001`
15. Ran tests using `sudo /vagrant/test/runbats.sh`
16. Wordpress install page failed, others completed
17. Browsed on host system to `192.0.2.10`
18. Default Apache page visible
19. Browsed to `192.0.2.10/wordpress`
20. `Error establishing a database connection`
21. Added `host: 192.0.2.%` into `mariadb_users`
22. Browsed to `192.0.2.10/wordpress` on host system
23. Wordpress install page shows
24. `vagrant ssh pu001`
25. Ran tests using `sudo /vagrant/test/runbats.sh`

    Output:
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
    Running test /vagrant/test/pu001/lamp.bats
    ✓ The necessary packages should be installed
    ✓ The Apache service should be running
    ✓ The Apache service should be started at boot
    ✓ The MariaDB service should be running
    ✓ The MariaDB service should be started at boot
    ✓ The SELinux status should be ‘enforcing’
    ✓ Web traffic should pass through the firewall
    ✓ Mariadb should have a database for Wordpress
    ✓ The MariaDB user should have write
    ✓ The website should be accessible through HTTP
    ✓ The website should be accessible through HTTPS
    ✓ The certificate should not be the default one
    ✓ The Wordpress install page should be visible under http://192.0.2.10/wordpress/
    ✓ MariaDB should not have a test database
    ✓ MariaDB should not have anonymous users

    15 tests, 0 failures
    ```
24. Finished test plan
25. Wrote test report

## Test report

1. Executed `vagrant status`
    - `pu001` with status `aborted`. Destroyed with `vagrant destroy -f pu001`
3. Executed `vagrant up pu001`
    - No errors
4. Logged in on the server with `vagrant ssh pu001` and ran the acceptance tests. Output:

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
    Running test /vagrant/test/pu001/lamp.bats
    ✓ The necessary packages should be installed
    ✓ The Apache service should be running
    ✓ The Apache service should be started at boot
    ✓ The MariaDB service should be running
    ✓ The MariaDB service should be started at boot
    ✓ The SELinux status should be ‘enforcing’
    ✓ Web traffic should pass through the firewall
    ✓ Mariadb should have a database for Wordpress
    ✓ The MariaDB user should have write
    ✓ The website should be accessible through HTTP
    ✓ The website should be accessible through HTTPS
    ✓ The certificate should not be the default one
    ✓ The Wordpress install page should be visible under http://192.0.2.10/wordpress/
    ✓ MariaDB should not have a test database
    ✓ MariaDB should not have anonymous users
    ```

5. On the host sytem, browsed to `192.0.2.10`
6. An Apache welcome page is shown
7. On the host system, browsed to `192.0.2.10/wordpress`
8. A wordpress install page is shown

## Resources

### Generating SSL key on CentOS
- https://wiki.centos.org/HowTos/Https

### bertvv Role Variables
- https://github.com/bertvv/ansible-role-httpd
- https://github.com/bertvv/ansible-role-mariadb
- https://github.com/bertvv/ansible-role-wordpress

### Ansible documentation
- https://docs.ansible.com/ansible/latest/index.html