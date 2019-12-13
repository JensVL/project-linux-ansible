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
cant login with general users eventhough local users is enabled (according to test exit status)

## Test report

## Resources

### bertvv Role Variables

- <https://github.com/bertvv/ansible-role-samba>
- <https://github.com/bertvv/ansible-role-vsftp>
- <https://github.com/bertvv/ansible-role-rh-base>

### Samba

- <https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>
