#!/bin/bash

# 1 安装ssh
apt-get install ssh
sed -i 's/\#PasswordAuthentication\ no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/\#PermitRootLogin\ prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
/etc/init.d/ssh restart
