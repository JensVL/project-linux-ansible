# Enterprise Linux Lab Report

- Student name: Jens Van Liefferinge
- Github repo: <https://github.com/HoGentTIN/elnx-1920-sme-JensVL>

Setting up a Samba & vsftpd fileserver with user account imports & permissions.

## Test plan

1. On the host system, go to the local working directory of the project repository.
2. Execute `vagrant status`.
3. The VM with the name `pr011` should not exist. If the VM does exist, destroy it first with `vagrant destroy -f pr011`.
4. Execute `vagrant up pr011` to launch the fileserver.
    - The command should run without errors (exit status 0)
5. Log in on the fileserver with `vagrant ssh pr011` and run the acceptance tests using `sudo /vagrant/test/runbats.sh`. The common and samba tests should succeed:

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
Running test /vagrant/test/pr011/samba.bats
 ✓ The ’nmblookup’ command should be installed
 ✓ The ’smbclient’ command should be installed
 ✓ The Samba service should be running
 ✓ The Samba service should be enabled at boot
 ✓ The WinBind service should be running
 ✓ The WinBind service should be enabled at boot
 ✓ The SELinux status should be ‘enforcing’
 ✓ Samba traffic should pass through the firewall
 ✓ Check existence of users
 ✓ Checks shell access of users
 ✓ Samba configuration should be syntactically correct
 ✓ NetBIOS name resolution should work
 ✓ read access for share ‘public’
 ✓ write access for share ‘public’
 ✓ read access for share ‘management’
 ✓ write access for share ‘management’
 ✓ read access for share ‘technical’
 ✓ write access for share ‘technical’
 ✓ read access for share ‘sales’
 ✓ write access for share ‘sales’
 ✓ read access for share ‘it’
 ✓ write access for share ‘it’

22 tests, 0 failures
```

6. The vsftpd tests should succeed up until the shares tests:

```console
22 tests, 0 failures
Running test /vagrant/test/pr011/vsftp.bats
 ✓ VSFTPD service should be running
 ✓ VSFTPD service should be enabled at boot
 ✓ The ’curl’ command should be installed
 ✓ The SELinux status should be ‘enforcing’
 ✓ FTP traffic should pass through the firewall
 ✓ VSFTPD configuration should be syntactically correct
 ✓ Anonymous user should not be able to see shares
 ✗ read access for share ‘public’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 135)
     `assert_read_access     public     alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘public’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 153)
     `assert_write_access    public     alexanderd    alexanderd' failed with status 67
 ✗ read access for share ‘management’
   (from function `assert_no_read_access' in file /vagrant/test/pr011/vsftp.bats, line 48,
    in test file /vagrant/test/pr011/vsftp.bats, line 171)
     `assert_no_read_access  management alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘management’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 193)
     `assert_write_access    management elenaa        elenaa' failed with status 67
 ✗ read access for share ‘technical’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 207)
     `assert_read_access     technical  alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘technical’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 225)
     `assert_write_access    technical  alexanderd    alexanderd' failed with status 67
 ✗ read access for share ‘sales’
   (from function `assert_no_read_access' in file /vagrant/test/pr011/vsftp.bats, line 48,
    in test file /vagrant/test/pr011/vsftp.bats, line 243)
     `assert_no_read_access  sales      alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘sales’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 263)
     `assert_write_access    sales      benoitp       benoitp' failed with status 67
 ✗ read access for share ‘it’
   (from function `assert_no_read_access' in file /vagrant/test/pr011/vsftp.bats, line 48,
    in test file /vagrant/test/pr011/vsftp.bats, line 279)
     `assert_no_read_access  it         alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘it’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 300)
     `assert_write_access    it         christophev   christophev' failed with status 67

17 tests, 10 failures
```

## Procedure/Documentation

1. Downloaded the [bertvv samba role](<https://github.com/bertvv/ansible-role-samba>) into /ansible/roles
2. Downloaded the [bertvv vsftpd role](<https://github.com/bertvv/ansible-role-vsftpd>) into /ansible/roles
3. Added roles into [site.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/site.yml)
4. Added `file` group into `group_vars`
5. Added samba configuration variables into [file.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/file.yml)
6. Launched `pr011`
7. Ran tests: most failed
8. added users into [all.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/all.yml)
9. Launched `pr011`
10. User logins fail
11. Added password hashes instead of plaintext passwords into [all.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/all.yml)
12. Added configuration for a public group
13. Launched VM and ran tests: public share test fails
14. Added all groups into public share: [samba_shares variable](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/file.yml)
15. Uncommented specific share tests
16. Ran tests:

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
Running test /vagrant/test/pr011/samba.bats
 ✓ The ’nmblookup’ command should be installed
 ✓ The ’smbclient’ command should be installed
 ✓ The Samba service should be running
 ✓ The Samba service should be enabled at boot
 ✓ The WinBind service should be running
 ✓ The WinBind service should be enabled at boot
 ✓ The SELinux status should be ‘enforcing’
 ✓ Samba traffic should pass through the firewall
 ✓ Check existence of users
 ✓ Checks shell access of users
 ✓ Samba configuration should be syntactically correct
 ✓ NetBIOS name resolution should work
 ✓ read access for share ‘public’
 ✓ write access for share ‘public’
 ✓ read access for share ‘management’
 ✓ write access for share ‘management’
 ✓ read access for share ‘technical’
 ✓ write access for share ‘technical’
 ✓ read access for share ‘sales’
 ✓ write access for share ‘sales’
 ✓ read access for share ‘it’
 ✓ write access for share ‘it’

22 tests, 0 failures
```

17. Added basic vsftpd configuration into [file.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/file.yml):

```console
vsftpd_anonymous_enable: false
vsftpd_local_enable: true
vsftpd_write_enable: true
```

18. Booted VM and ran vfstpd tests:

```console
22 tests, 0 failures
Running test /vagrant/test/pr011/vsftp.bats
 ✓ VSFTPD service should be running
 ✓ VSFTPD service should be enabled at boot
 ✓ The ’curl’ command should be installed
 ✓ The SELinux status should be ‘enforcing’
 ✓ FTP traffic should pass through the firewall
 ✓ VSFTPD configuration should be syntactically correct
 ✓ Anonymous user should not be able to see shares
 ✗ read access for share ‘public’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 135)
     `assert_read_access     public     alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘public’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 153)
     `assert_write_access    public     alexanderd    alexanderd' failed with status 67
 ✗ read access for share ‘management’
   (from function `assert_no_read_access' in file /vagrant/test/pr011/vsftp.bats, line 48,
    in test file /vagrant/test/pr011/vsftp.bats, line 171)
     `assert_no_read_access  management alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘management’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 193)
     `assert_write_access    management elenaa        elenaa' failed with status 67
 ✗ read access for share ‘technical’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 207)
     `assert_read_access     technical  alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘technical’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 225)
     `assert_write_access    technical  alexanderd    alexanderd' failed with status 67
 ✗ read access for share ‘sales’
   (from function `assert_no_read_access' in file /vagrant/test/pr011/vsftp.bats, line 48,
    in test file /vagrant/test/pr011/vsftp.bats, line 243)
     `assert_no_read_access  sales      alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘sales’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 263)
     `assert_write_access    sales      benoitp       benoitp' failed with status 67
 ✗ read access for share ‘it’
   (from function `assert_no_read_access' in file /vagrant/test/pr011/vsftp.bats, line 48,
    in test file /vagrant/test/pr011/vsftp.bats, line 279)
     `assert_no_read_access  it         alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘it’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 300)
     `assert_write_access    it         christophev   christophev' failed with status 67

17 tests, 10 failures
```

19. Added extra permissions into [file.yml](https://github.com/HoGentTIN/elnx-1920-sme-JensVL/blob/solution/ansible/group_vars/file.yml):

```console
vsftpd_extra_permissions:
  - folder: "/srv/shares/management"
    entity: "management"
    etype: "group"
    permissions: "rwx"
  - folder: "/srv/shares/sales"
    entity: "sales"
    etype: "group"
    permissions: "rwx"
  - folder: "/srv/shares/it"
    entity: "it"
    etype: "group"
    permissions: "rwx"
  - folder: "/srv/shares/technical"
    entity: "technical"
    etype: "group"
    permissions: "rwx"
  - folder: "/srv/shares/public"
    entity: "public"
    etype: "group"
    permissions: "rwx"
  - folder: "/srv/shares/technical"
    entity: "it"
    etype: "group"
    permissions: "r--"
  - folder: "/srv/shares/technical"
    entity: "management"
    etype: "group"
    permissions: "r--"
  - folder: "/srv/shares/technical"
    entity: "sales"
    etype: "group"
    permissions: "r--"
  - folder: "/srv/shares/it"
    entity: "management"
    etype: "group"
    permissions: "r--"
  - folder: "/srv/shares/sales"
    entity: "management"
    etype: "group"
    permissions: "r--"
```

20. Tests still fail like in step 18
21. Added umask configuration:

```console
vsftpd_local_umask: 002
```

22. Tests still fail: can't login with general users eventhough local users is enabled (according to test exit status): from vsftpd.bats: `curl_err_failed_to_log_in=67`
23. Tried using another role: [weareinteractive.vsftpd](https://github.com/weareinteractive/ansible-vsftpd)
24. Added user config for new role
25. Ran tests:

```console
[vagrant@pr011 ~]$ sudo /vagrant/test/runbats.sh
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
Running test /vagrant/test/pr011/samba.bats
 ✓ The ’nmblookup’ command should be installed
 ✓ The ’smbclient’ command should be installed
 ✓ The Samba service should be running
 ✓ The Samba service should be enabled at boot
 ✓ The WinBind service should be running
 ✓ The WinBind service should be enabled at boot
 ✓ The SELinux status should be ‘enforcing’
 ✓ Samba traffic should pass through the firewall
 ✓ Check existence of users
 ✓ Checks shell access of users
 ✓ Samba configuration should be syntactically correct
 ✓ NetBIOS name resolution should work
 ✓ read access for share ‘public’
 ✓ write access for share ‘public’
 ✓ read access for share ‘management’
 ✓ write access for share ‘management’
 ✓ read access for share ‘technical’
 ✓ write access for share ‘technical’
 ✓ read access for share ‘sales’
 ✓ write access for share ‘sales’
 ✓ read access for share ‘it’
 ✓ write access for share ‘it’

22 tests, 0 failures
Running test /vagrant/test/pr011/vsftp.bats
 ✓ VSFTPD service should be running
 ✓ VSFTPD service should be enabled at boot
 ✓ The ’curl’ command should be installed
 ✓ The SELinux status should be ‘enforcing’
 ✓ FTP traffic should pass through the firewall
 ✓ VSFTPD configuration should be syntactically correct
 ✓ Anonymous user should not be able to see shares
 ✗ read access for share ‘public’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 135)
     `assert_read_access     public     alexanderd    alexanderd' failed with status 9
 ✗ write access for share ‘public’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 153)
     `assert_write_access    public     alexanderd    alexanderd' failed with status 9
 ✗ read access for share ‘management’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 175)
     `assert_read_access     management elenaa        elenaa' failed with status 9
 ✗ write access for share ‘management’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 193)
     `assert_write_access    management elenaa        elenaa' failed with status 9
 ✗ read access for share ‘technical’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 207)
     `assert_read_access     technical  alexanderd    alexanderd' failed with status 9
 ✗ write access for share ‘technical’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 225)
     `assert_write_access    technical  alexanderd    alexanderd' failed with status 9
 ✗ read access for share ‘sales’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 245)
     `assert_read_access     sales      benoitp       benoitp' failed with status 9
 ✗ write access for share ‘sales’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 263)
     `assert_write_access    sales      benoitp       benoitp' failed with status 9
 ✗ read access for share ‘it’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 282)
     `assert_read_access     it         christophev   christophev' failed with status 9
 ✗ write access for share ‘it’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 300)
     `assert_write_access    it         christophev   christophev' failed with status 9

17 tests, 10 failures
```

26. According to testfile: `curl_err_access_denied=9` & `curl_err_retr_failed=9`
27. Destroyed VM and rebooted
28. Ran tests again:

```console
22 tests, 0 failures
Running test /vagrant/test/pr011/vsftp.bats
 ✓ VSFTPD service should be running
 ✓ VSFTPD service should be enabled at boot
 ✓ The ’curl’ command should be installed
 ✓ The SELinux status should be ‘enforcing’
 ✓ FTP traffic should pass through the firewall
 ✓ VSFTPD configuration should be syntactically correct
 ✓ Anonymous user should not be able to see shares
 ✗ read access for share ‘public’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 135)
     `assert_read_access     public     alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘public’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 153)
     `assert_write_access    public     alexanderd    alexanderd' failed with status 67
 ✗ read access for share ‘management’
   (from function `assert_no_read_access' in file /vagrant/test/pr011/vsftp.bats, line 48,
    in test file /vagrant/test/pr011/vsftp.bats, line 171)
     `assert_no_read_access  management alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘management’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 193)
     `assert_write_access    management elenaa        elenaa' failed with status 67
 ✗ read access for share ‘technical’
   (from function `assert_read_access' in file /vagrant/test/pr011/vsftp.bats, line 37,
    in test file /vagrant/test/pr011/vsftp.bats, line 207)
     `assert_read_access     technical  alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘technical’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 225)
     `assert_write_access    technical  alexanderd    alexanderd' failed with status 67
 ✗ read access for share ‘sales’
   (from function `assert_no_read_access' in file /vagrant/test/pr011/vsftp.bats, line 48,
    in test file /vagrant/test/pr011/vsftp.bats, line 243)
     `assert_no_read_access  sales      alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘sales’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 263)
     `assert_write_access    sales      benoitp       benoitp' failed with status 67
 ✗ read access for share ‘it’
   (from function `assert_no_read_access' in file /vagrant/test/pr011/vsftp.bats, line 48,
    in test file /vagrant/test/pr011/vsftp.bats, line 279)
     `assert_no_read_access  it         alexanderd    alexanderd' failed with status 67
 ✗ write access for share ‘it’
   (from function `assert_write_access' in file /vagrant/test/pr011/vsftp.bats, line 61,
    in test file /vagrant/test/pr011/vsftp.bats, line 300)
     `assert_write_access    it         christophev   christophev' failed with status 67

17 tests, 10 failures
```

29. Tried to change crypt method to crypt-md5 -> not supported
30. Added `20/tcp` and `21/tcp` ports to firewall exception
31. Destroyed VM , rolled back to bertvv vsftpd and rebooted VM
32. Same result as step 28

## Test report

## Resources

### bertvv Role Variables

- <https://github.com/bertvv/ansible-role-samba>
- <https://github.com/bertvv/ansible-role-vsftpd>
- <https://github.com/bertvv/ansible-role-rh-base>

### Samba

- <https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>

### VSFTPD

- <https://www.howtoforge.com/tutorial/how-to-install-and-configure-vsftpd/>
- <https://security.appspot.com/vsftpd.html#docs>
- <https://support.rackspace.com/how-to/installing-and-configuring-vsftpd/>
- <https://github.com/weareinteractive/ansible-vsftpd>
- <https://github.com/weareinteractive/ansible-openssl>
