# DEMO

## pu001

- Boot VM
- run tests
- Possible mariadb workaround:
  - Run `mysql -u root -p` to log in as root user.
  - Enter `root` as password.
  - Eexecute `grant all privileges on *.* to user1@localhost identified by 'password' with grant option;`.
  - Exit out of the MariaDB shell using `exit`.
  - Try to log in with the user: `mysql -u user1 -p`.
  - Enter `password` as password.
  - use wp_db
- On host, go to <https://192.0.2.10/>
- show Apache page
- show certificate, also in project directory
- go to <https://192.0.2.10/wordpress>
- show page

- avalon.lan doesnt work

## pr001

- boot VM
- run tests
- Verify Fail2ban is running by executing the following command: `systemctl status fail2ban`. Status should be active (running).

## pr002

- boot VM
- run tests

## pr011

- boot VM
- boot workstation
- run tests

- vsftpd doesnt work fully

- on host, go to `\\files\`
- enter jens - jens
- shares visible
- try enter management
- try enter files into technical
- enter IT and make folder to show

- on workstation, go to `smb://files/`
- enter a folder
- login jens - AVALON - jens
- try enter management
- try enter files into technical
- enter IT and make folder to show

- SSH into vm
- Try to log in using the `leend` account: `su leend`.
- Enter `leend` as password.
- A message saying `This account is currently not available.` should come up.
- Try to log in using the `nehirb` account: `su nehirb`.
- Enter `nehirb` as password.
- The login should succeed.
- Verify the created home directories: execute `cd /home`.
- Execute `ls`. Every user should have a directory.
- Try entering another user's directory. For example: `cd evyt`.
- Access should be denied.
- Verify the created user groups by executing `vim /etc/group` and scrolling to the bottom of the list to verify the created groups have the correct users.
- Return to the vagrant account using `su vagrant` and `vagrant` as password.
- Open a new terminal window on host syystem.
- Try to ssh using `ssh nehirb@172.16.192.11`.
- Enter a wrong password 3 times. The correct password is `nehirb`.
- Execute `ssh nehirb@172.16.192.11` again.
- Enter a wrong password 2 times.
- On the fifth attempt the connection should time out.
- In the vagrant ssh sesion, execute `sudo iptables -L f2b-sshd`.
- A new entry should be visible, denying traffic.

## router

- boot VM
- boot test1 workstation
- dhcp config doesnt work
- ssh into pu001
  - ping 172.16.192.15
  - ping 172.16.192.11
  - ping 172.16.0.1
  - ping 10.0.2.15
- ssh into router
  - ping 192.0.2.10
  - ping 172.16.192.15 - doesnt work
  - ping 172.16.192.11 - doesnt work
- ssh into pr001
  - ping 172.16.192.10
  - ping 172.16.192.11
  - ping 172.16.0.1 - doesnt work
  - ping 10.0.2.15
- open workstation terminal
  - ping 192.0.2.15 - doesnt work
  - ping 172.16.192.1
  - ping 172.16.192.11
  - ping 172.16.0.1 - doesnt work
  - ping 10.0.2.15 - doesnt work
