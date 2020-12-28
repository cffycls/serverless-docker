# serverless自定义docker环境

旨在用于serverless部署环境，运行对象是阿里云，打造属于您自己的Runtime。

## 一、容器镜像
### 1.自定义PHP镜像

更新PHP镜像: php:7.4.13; swoole:4.6.0
```shell script
docker pull cffycls/php
```
容器中要有持续运行的程序，不然自动关闭

### 2.node使用官方

官方: node:v15.5.0
```shell script
docker pull node
```

### 3.php_node组合镜像

自定义制作
```shell script
docker pull cffycls/php_node
```

## 二、自定义运行时

函数计算 > 代码开发 > Custom Runtime > 简介

[https://help.aliyun.com/document_detail/132044.html](https://help.aliyun.com/document_detail/132044.html)
