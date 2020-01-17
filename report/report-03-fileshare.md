# Enterprise Linux Lab Report

- Student name: Jens Van Liefferinge
- Github repo: <https://github.com/HoGentTIN/elnx-1920-sme-JensVL>

Setting up a Samba fileserver with user account imports & permissions.

## Test plan

## Procedure/Documentation

add config
add users
vagrant up
add password hash
add public group
public test fails
add all groups to public share
uncomment skipped tests
all samba test successful
add vsftpd config
cant login with general users eventhough local users is enabled (according to test exit status) curl_err_failed_to_log_in=67

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
