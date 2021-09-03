很多在校的学生，特别是研究生，往往需要在校外访问校内的资源，有时候，甚至需要登陆校内自己的台式机。但是，学校一般会设计一个网关，让学生用vpn登陆，这就带来许多不便的地方。这里介绍另一种方式（FPR），可以实现内网穿透。 

我有一台长期运行VPN的VPS，选择的是DigitalOcean的伦敦机房，速度和稳定性都不错。就用它作为FPR的服务器。 

首先，去[FPR的网站](https://github.com/fatedier/frp/releases)下载需要的文件frp\_0.16.1\_linux\_amd64.tar.gz。我下载时是0.16.1版本，后续一定会有更新，但反正认准linux\_amd\_64就行。 

上传到VPS，然后解压，打开当中的frps.ini，按照下面写入： 

```shell
[common]

bind_port = 8888

bind_addr = 0.0.0.0

auto_token = frp
```

然后保存。服务器端需要先开启，开启的命令非常简单：

 ./frps -c ./frps.ini 

然后就是到客户端配置，过程非常类似。 

这里我以自己家里放着的树莓派为例。由于树莓派是ARM架构的处理器，选择linux\_arm的FPR即可。同样将文件上传，解压，然后配置的是frpc.ini，写入下面这段： 

```shell
[common]

server_addr = xxx.xxx.xxx.xxx

server_port = 8888

auto_token = frp

[ssh]

type = tcp

local_ip = 127.0.0.1

local_port = 22

remote_port = 99999
```

server\_addr是服务器端的公网IP地址，server\_port是frp服务端口号，auto\_token是连接服务器的口令，必须和服务器保持一致。[ssh]是客户端通过服务器与用户之间的通道名，每个客户端必须不一样，remote\_port是服务器端对外提供本机服务的端口号，即用户连接xxx.xxx.xxx.xxx:99999，相当于连接127.0.0.1:22,即树莓派上的ssh服务。 

开启客户端的方式和服务器端一致： 

`./frpc -c ./frpc.ini`

然后，只要在外网，

`ssh pi@xxx.xxx.xxx.xxx -p 99999`

就可以愉快地登陆啦。 

注意：客户端的时钟不能和服务器端时钟相差太大！否则会出现认证超时的错误:authorization timeout 

这个超时时间可以在配置文件中通过 authentication\_timeout 这个参数来修改，单位为秒，默认值为 900，即 15 分钟。如果修改为 0，则 frps 将不对身份验证报文的时间戳进行超时校验。 

为了方便，我在服务器端选择后台运行FPR： 

```shell
#!/bin/sh

ssserver -c /etc/shadowsocks.json -d start

cd /root/frp_0.16.1_linux_amd64

nohup ./frps -c ./frps.ini >& log &

cd
```

