当管理数以十计或者更多的系统时，常常需要在多台机器上执行相同的命令，可以使用一个小工具pdsh。

首先必须在管理节点和每台目标机器上都安装pdsh软件包。pdsh可以在指定的一组机器上执行同一个命令。例如需要管理下列机器，机器名分别为srv1,srv2,srv3,srv4,srv5。 

命令格式如下: 

pdsh -w [SSH\_OR\_RSH]:USERNAME@srv[1,2-4,5] [COMMAND]

有时需要在每台机器上执行一组也许不确定的命令，这时可以省略 

[COMMAND]部分,用法如下: 

```shell
[root@client1 ~]$ pdsh -w ssh:tonyzhang@srv[1,2-4,5]

pdsh> hostname

srv1: srv1.example.zqin

srv2: srv2.example.zqin

srv3: srv3.example.zqin

srv4: srv4.example.zqin

srv5: srv5.example.zqin

pdsh> date

srv1: Sat Apr 16 07:50:01 EDT 2011

srv2: Sat Apr 16 07:59:01 EDT 2011

srv3: Sat Apr 16 07:48:01 EDT 2011

srv4: Sat Apr 16 07:40:01 EDT 2011

srv5: Sat Apr 16 07:51:01 EDT 2011

pdsh> exit
```

pdsh软件包还包括一个pdcp命令，可以将文件拷贝到一组机器上，用法如下: 

pdsh -w [SSH\_OR\_RSH]:[USERNAME]@nodesrv[1,2-4,5] SRCFILE DES

想将文件test.docx拷贝到上述机器的/doc当中，可执行下列命令: 

pdcp -w ssh:root@srv[1,2-4,5] test.docx /doc