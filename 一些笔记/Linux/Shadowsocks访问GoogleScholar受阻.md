在最近一段时间，访问Google Scholar时总会遇到下面这个问题，但是访问Google却是正常的 

![](resources/B12FD78EEFD09A9C2F93237FC771E3C9)

其原因可能是IPv4或IPv6网段有人做爬虫，网段被封。Google虽然给出了如验证码等方式，但至少我这里没有出现过，发消息给Google也没有回音，因此只能自行解决。 

如果是IPv6网段被封

强制VPS使用IPv4访问，编辑/etc/sysctl.conf，在后面加上如下代码，禁止IPv6访问： 

\# disable ipv6

net.ipv6.conf.all.disable\_ipv6=1

net.ipv6.conf.default.disable\_ipv6=1

net.ipv6.conf.lo.disable\_ipv6=1

重启Shadowsocks后，看是否能访问。我这里没有成功，说明是IPv4网段被封。 

如果是IPv4网段被封

强制VPS使用IPv6访问，更改VPS的hosts中指定Google Schoolar的IPv6地址就好了，编辑/etc/hosts，在后面加上： 

\#\# Scholar 学术搜索

2404:6800:4004:81a::200e scholar.google.cn

2404:6800:4004:81a::200e [scholar.google.com.hk](http://scholar.google.com.hk)

2404:6800:4004:81a::200e [scholar.google.com](http://scholar.google.com)

2404:6800:4004:81a::200e [scholar.l.google.com](http://scholar.l.google.com)

前面是IPv6地址，可用 host [google.com](http://google.com)获取最新的 

重启Shadowsocks后能够重新访问Google Scholar。