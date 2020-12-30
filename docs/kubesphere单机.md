# 在 Linux 上安装 All-in-one KubeSphere

[https://kubesphere.com.cn/](https://kubesphere.com.cn/)

## 一、debian10安装KubeSphere
机器配置参照官方，这里使用 `debian10(无桌面): 4C,8G,90G`

### 1.使用官方命令安装

```shell script
# 1).下载安装脚本和文件
curl -sfL https://get-kk.kubesphere.io | VERSION=v1.0.1 sh -
# 2).执行自动安装
chmod +x kk
./kk create cluster --with-kubesphere v3.0.0 # --with-kubernetes v1.17.9 默认
# 3).检查是否完成
kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l app=ks-install -o jsonpath='{.items[0].metadata.name}') -f
```

### 2.docker加速

```shell script
root@debian10:~# cat /etc/docker/daemon.json
{
  "registry-mirrors": ["https://kuogup1r.mirror.aliyuncs.com"],
  "dns": ["8.8.8.8"],
  "log-opts": {
    "max-size": "5m",
    "max-file":"3"
  },
  "exec-opts": ["native.cgroupdriver=systemd"]
}
```

>systemctl restart docker

加入上面的2行`{registry-mirrors, dns}`项，再次执行自动安装。多次重试，直到出现
```shell script
#####################################################
###              Welcome to KubeSphere!           ###
#####################################################

Console: http://192.168.2.25:30880
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
https://kubesphere.io             2020-12-29 17:14:21
#####################################################
```

## 二、操作使用

### 1.后台使用学习
#### 精华参考

《 [应用程序生命周期管理](https://kubesphere.com.cn/docs/application-store/app-lifecycle-management/) 》

### 2.应用部署实战

#### mysql集群操作
《 [Kubesphere搭建MySQL集群](https://blog.csdn.net/CSDN877425287/article/details/108610639) 》

配置文件《[MySql集群搭建](https://blog.csdn.net/CSDN877425287/article/details/108380289)》

#### 注意事项

- 必须设置密码 MYSQL_ROOT_PASSWORD
- 数据目录 /var/lib/mysql-files
