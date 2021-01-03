#!/bin/bash
### 0 允许密码认证登录
if [[ $(id | grep root) == "" ]]; then
  sudo su
  echo "go to root"
fi
id

### 1、环境初始化
# 1.1 关闭防火墙功能
apt-get install -y ufw && systemctl ufw disable
# 1.2.关闭selinux
# 1.3 关闭swap，启动项
swapoff -a
sed -i.bak '/swap/s/^/#/' /etc/fstab
# 1.4 服务器规划
result=$(cat /etc/hosts | grep "节点主机")
if [[ "$result" != "" ]]; then
    echo
else
    cat <<EOF >>  /etc/hosts
#节点主机
192.168.1.121 node1
192.168.1.122 node2
192.168.1.123 node3

# GitHub githubusercontent 超时备用
199.232.68.133 raw.githubusercontent.com
EOF
fi
# 1.5 临时主机名配置方法，vagrant设置、略 hostnamectl set-hostname master1
# 1.6 时间同步：ntp、chrony
timedatectl set-timezone Asia/Shanghai
apt-get install chrony -y
cat <<EOF >  /etc/chrony.conf
server ntp1.aliyun.com iburst minpoll 4 maxpoll 10
server ntp2.aliyun.com iburst minpoll 4 maxpoll 10
server ntp3.aliyun.com iburst minpoll 4 maxpoll 10
EOF
systemctl start chronyd.service
systemctl enable chronyd.service
# 1.7 开启转发，即要求iptables不对bridge的数据进行处理
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF


### 2、docker安装
# 2.1 更新主机源
cat <<EOF > /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
EOF
#apt-get update

# 2.2 安装docker: https://docs.docker.com/engine/install/debian/
apt-get clean && apt-get update --fix-missing
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common 
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
apt-get update
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
# 2.3 docker配置
mkdir -p /etc/docker 
cat <<EOF > /etc/docker/daemon.json
{
    "graph": "/data/docker",
    "registry-mirrors": ["https://kuogup1r.mirror.aliyuncs.com"],
    "dns": ["8.8.8.8"],
    "log-opts": {
        "max-size": "5m",
        "max-file":"3"
    },
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
# 2.4添加用户
usermod -aG docker vagrant
systemctl restart docker && systemctl enable docker
docker -v

apt autoremove

echo ">> 完成!"