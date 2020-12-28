# dockerfile命令说明

## 1.apk add 参数

 - --no-cache
 
    不使用本地缓存安装包数据库，直接从远程获取安装包信息安装。这样我们就不必通过apk update获取安装包数据库了
    
 - --virtual .build-deps
 
    将本次安装的所有包封装成一个名为.build-deps的虚拟包。这样做的好处是可以通过apk del .build-deps一键清除这些包