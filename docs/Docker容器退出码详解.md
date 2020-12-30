# [Docker容器退出码详解](https://blog.csdn.net/qq_39503880/article/details/110266041)

docker查看退出码指令
```shell script
docker ps --filter "status=exited"
docker inspect 　container-id --format='{{.State.ExitCode}}'
```

# 常见退出码

### Exit Code 0
- 退出代码0表示特定容器没有附加前台进程。
- 该退出代码是所有其他后续退出代码的例外。
- 这不一定意味着发生了不好的事情。如果开发人员想要在容器完成其工作后自动停止其容器，则使用此退出代码。

### Exit Code 1
- 程序错误，或者Dockerfile中引用不存在的文件，如 entrypoint中引用了错误的包
- 程序错误可以很简单，例如“除以0”，也可以很复杂，比如空引用或者其他程序 crash

### Exit Code 137
- 此状态码一般是因为 pod 中容器内存达到了它的资源限制(resources.limits)，一般是内存溢出(OOM)，CPU达到限制只需要不分时间片给程序就可以。因为限制资源是通过 linux 的 cgroup 实现的，所以 cgroup 会将此容器强制杀掉，类似于kill -9
- 还可能是宿主机本身资源不够用了(OOM)，内核会选取一些进程杀掉来释放内存
- 不管是 cgroup 限制杀掉进程还是因为节点机器本身资源不够导致进程死掉，都可以从系统日志中找到记录(journalctl -k)

### Exit Code 139
- 表明容器收到了SIGSEGV信号，无效的内存引用，对应kill -11
一般是代码有问题，或者 docker 的基础镜像有问题

### Exit Code 143
- 表明容器收到了SIGTERM信号，终端关闭，对应kill -15
- 一般对应docker stop 命令
- 有时docker stop也会导致Exit Code 137。发生在与代码无法处理SIGTERM的情况下，docker进程等待十秒钟然后发出SIGKILL强制退出。

### 不常用的一些 Exit Code
- Exit Code 126: 权限问题或命令不可执行
- Exit Code 127: Shell脚本中可能出现错字且字符无法识别的情况
- Exit Code 1 或 255：因为很多程序员写异常退出时习惯用 exit(1) 或 exit(-1)，-1 会根据转换规则转成 255。这个一般是自定义 code，要看具体逻辑。

### 退出状态码的区间
- 必须在 0-255 之间，0 表示正常退出
- 外界将程序中断退出，状态码在 129-255
- 程序自身异常退出，状态码一般在 1-128
- 假如写代码指定的退出状态码时不在 0-255 之间，例如: exit(-1)，这时会自动做一个转换，最终呈现的状态码还是会在 0-255 之间。我们把状态码记为 code，当指定的退出时状态码为负数，那么转换公式如下：256 – (|code| % 256)
参考链接：　https://imroc.io/posts/kubernetes/analysis-exitcode/