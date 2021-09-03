VPS 
----

VPS（Virtual Private Server 虚拟专用服务器）技术，将一台服务器分割成多个虚拟专享服务器的优质服务。实现VPS的技术分为容器 技术，和虚拟化技术。在容器或虚拟机中，每个VPS都可分配独立公网IP地址、独立操作系统、实现不同VPS间磁盘空间、内存、CPU资源、进程和系统配置的隔离，为用户和应用程序模拟出“独占”使用计算资源的体验。VPS可以像独立服务器一样，重装操作系统，安装程序，单独重启服务器。VPS为使用者提供了管理配置的自由，可用于企业虚拟化，也可以用于IDC资源租用。 

比较流行的国外VPS有[DigitalOcean](https://www.digitalocean.com/)，[Linode](https://www.linode.com/)，[Vultr](https://www.vultr.com/)，[SugarHosts](http://www.sugarhosts.com/)，[VPS.NET](https://www.vps.net/),[BandwagonHost](https://bwh1.net/index.php)等等，国内VPS有[阿里云](http://www.aliyun.com/),[腾讯云](http://www.qcloud.com/)等等。 

Shadowsocks 
------------

Shadowsocks的中文名叫影梭。利用Python，C和C\#开发。主要在中国大陆用于翻墙。Shadowsocks有自己的[github](https://github.com/shadowsocks)，同时支持购买专属账户进行翻墙([这里是链接](https://shadowsocks.com/))。如果我们拥有一台国外的VPS，我们可以利用VPS自己搭建一个SSServer进行翻墙。相比于传统的PPTP，L2TP，IPSec等VPN，Shadowsocks更加稳定，而且速度更快，同时对苹果的系列产品更加适用。下面我们用笔者的DigitalOcean账户作为示范进行SSServer搭建说明。 

### SSH 

SSH key是一个简单而又安全地连接到你的远端设备的方式，通过它你不需要在网络上传输你的密码。SSH key有public和private两部分，其中private部分存储在你的设备本地，而public部分则需要上传到远程设备上。当你通过ssh连接到远程设备上时，只有私钥和公钥匹配上才能登陆。首先查看本机上有没有SSH key： 

`ls ~/.ssh/*.pub`

如果没有任何输出，说明你需要自己新建一个： 

`ssh-keygen -t rsa -C "<email@example.com>"`

后面的email请替换成自己的email。

然后就会看到如下的信息：

```
Generating public/private rsa key pair.

Enter file in which to save the key (/Users/you/.ssh/id_rsa): [Press enter]

Enter passphrase (empty for no passphrase): [Type a passphrase]

Enter same passphrase again: [Type passphrase again]

Now your SSH key will be generated.

Your identification has been saved in /Users/your_username/.ssh/id_rsa.

Your public key has been saved in /Users/your_username/.ssh/id_rsa.pub.

The key fingerprint is:

01:0f:f4:3b:ca:85:d6:17:a1:7d:f0:68:9d:f0:a2:db email@example.com
```

然后就可以在~/.ssh目录下找到一个名为id\_rsa.pub的文件，这个文件就是公钥，请妥善保存。

接下来： 

`vi ~/.ssh/id\_rsa.pub`

把里面的内容全部拷贝出来以后，登录到你的VPS账号下： 

`vi ~/.ssh/authorized\_keys`

然后把刚刚从id\_rsa.pub里拷贝的东西粘贴到这个文件里，保存。

这样就可以实现VPS的免密码登录了。 

### SSServer搭建 

笔者的VPS选择的是CentOS系统，RedHat系列的其他系统也可以仿照如下命令安装Shadowsocks：

```shell
yum install python-setuptools && easy_install pip

pip install shadowsocks
```

Debian系列的系统，如Ubuntu，可以用下面的命令：

```shell
apt-get install python-pip

pip install shadowsocks
```

pip是什么就不赘述了，不知道的话还是先补充一些基础知识。 

安装好Shadowsocks以后，启动Shadowsocks服务可以通过以下指令： 

`ssserver -p 8836 -kpassword-m rc4-md5`

或者可以通过以下指令在后台启动/关闭Shadowsocks的服务：

```shell
ssserver -p 8836 -k password -m rc4-md5 -d start

ssserver -p 8836 -k password -m rc4-md5 -d stop
```

但上面的方法很不方便，所以可以选择下面这种方式：

首先创建一个文件/etc/shadowsocks.json，然后把下面的内容拷贝进去：

```
{

"server":"你的服务器ip地址",

"server_port":8388,

"local_address": "127.0.0.1",

"local_port":1080,

"password":"你设置的密码",

"timeout":300,

"method":"aes-256-cfb",

"fast_open": false

}
```

注意，8388是Shadowsocks服务的固定端口，就像80端口一般用于网站。

接下来你就可以使用下面这个指令启动服务： 

`ssserver -c /etc/shadowsocks.json`

或者在后台运行/停止：

```
ssserver -c /etc/shadowsocks.json -d start

ssserver -c /etc/shadowsocks.json -d stop
```

笔者选择的是把命令加入到/etc/rc.local中，这样就可以开机启动啦~ 

### 客户端 

Shadowsocks提供了很多客户端，尤其是支持OpenWRT，让OpenWRT路由器全局翻墙成为可能。具体内容请看[github客户端主页](https://github.com/shadowsocks/shadowsocks/wiki/Ports-and-Clients)。 

PS：有时候Shadowsocks在github上的项目会因为一些法律法规问题被删除，但是别着急，在里面多逛逛，还是可以找到的~ 

NOTE 
=====

CentOS 7 对防火墙进行了一些调整，需要通过下面两行命令用久开启8388端口并重启防火墙

```
firewall-cmd --zone=public --add-port=8388/tcp --permanent

firewall-cmd --reload
```

