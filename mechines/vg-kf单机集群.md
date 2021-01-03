# vagrant-kubesphere 单机集群的建立

- 缓存安装
这里共享单机安装时的下载文件缓存，加快安装速度。
- 局域网固定ip
可以在主机使用集群。

## 1.首先单机安装

>
/vagrant/tmp/kk create cluster --with-kubesphere v3.0.0

```shell script
#####################################################
###              Welcome to KubeSphere!           ###
#####################################################

Console: http://10.0.2.15:30880
Account: admin
Password: P@88w0rd

NOTES：
  1. After logging into the console, please check the
     monitoring status of service components in
     the "Cluster Management". If any service is not
     ready, please wait patiently until all components
     are ready.
  2. Please modify the default password after login.

#####################################################
https://kubesphere.io             2021-01-03 22:04:05
#####################################################
INFO[22:06:21 CST] Installation is complete.
```

不是理想的局域网IP，使用`http://192.168.1.123:30880/`测试，无法访问。并且均显示`http://10.0.2.15:30880`这个内网地址。