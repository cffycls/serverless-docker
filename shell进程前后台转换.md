shell进程前后台转换
进程前台与后台转换需要用到以下几个命令:
转自：http://blog.sina.com.cn/s/blog_5208a7520100qchm.html

```shell script

1. &
我们最常用到的就是这个命令了. 用法就是放在一个命令的最后, 可以把这个命令放到后台去执行. 大概用法如下:

$ tail -f log/* &
[1] 21867
# 这里 [1] 代表它是后台运行的一个 job 编号为 1
# 这里 21867 是它的进程号

2. ctrl + z
这也是常用到的快捷键. 用于将当前正在执行的前台进程放到后台, 并且暂停. 用法大致如下:

$ vi
# 按下 ctrl + z
[2]+ 

Stopped                vi
# 这里 [2] 代表它是后台运行的一个 job 编号为 2
# 这里 + 代表他是最近一个被放到后台的进程, 如果直接输入 fg 就是恢复这个进程.
# 这里 Stopped 说明它被停止了也就是 ctrl + z 的第二个作用 -- 暂停
# 这里 vi 就是进程名

3. jobs
查看当前后台运行的进程, 以 "[作业号][-/+] 运行状态 作业名称" 输出结果类似:

$ jobs
[1]- Running                tail -f log/* &
[2]+ Stopped                vi

2. fg
用于恢复后台进程到前台. 具体用法如下:

$ fg
# 将恢复 vi (还记得么 vi job 有一个加号, 它代表它是最近一次被放到后台的进程)
# 说明跟参数直接输入 fg 是恢复最近一次放入后台的进程到前台
# ctrl + z
[2]+ Stopped                vi
$ fg 1
# 将恢复 tail
# ctrl + z
[1]+ Stopped                tail -f log/*
$ jobs
[1]- Stopped                tail -f log/*
[2]+ Stopped                vi
# 再次注意 tail 变成了 Stopped, 并且没有 & 在句尾了

3. bg
用户把后台 stopped 的进程唤醒, 并且继续在后台运行. 具体用法如下:

$ bg 1
[1]+ tail -f log/* &
$ jobs
[1]- Running                tail -f log/* &
[2]+ Stopped                vi
# 当然 bg 也可以不跟参数就是唤醒最近放入后台的那个 stopped 进程(就是有 + 的那个)

```