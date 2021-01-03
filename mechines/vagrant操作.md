# debian10官方镜像

## 1.添加镜像
[https://vagrantcloud.com/generic/boxes/debian10/versions/3.1.20/providers/virtualbox.box](https://vagrantcloud.com/generic/boxes/debian10/versions/3.1.20/providers/virtualbox.box)

```
vagrant box add D:\迅雷下载\virtualbox.box --name debian10
```

## 2.局域网桥接网络设置

参考《 [vagrant虚拟化之多网卡网络配置](https://blog.csdn.net/yanggd1987/article/details/52574567) 》

### a.`public_network无法ping通网络中其他主机`
ifconfig 查看本地网络信息
```
eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.122  netmask 255.255.255.0  broadcast 192.168.1.255
        ether 08:00:27:5a:42:63  txqueuelen 1000  (Ethernet)
        RX packets 14  bytes 840 (840.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 6  bytes 550 (550.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
`node3.vm.network:public_network, ip: "192.168.1.123", bridge: "eth1", adapter: 2, auto_config: false`

设置后，反复多次启动，终于成功。主机间可以互 ping 成功，但对主机不通。

>进入“启动或关闭Windows Defender防火墙”，然后都设置为关闭。
（实测，笔者连接的为公用网络，关闭公用网络防火墙即可Ping成功）。

>特定端口参考下方。

## 3.关于宿主机对虚拟机的防火墙配置

参考《 [【实用指南】win10、linux文件共享服务（完备）](https://segmentfault.com/a/1190000022383656) 》

第二节 2.b 防火墙配置



