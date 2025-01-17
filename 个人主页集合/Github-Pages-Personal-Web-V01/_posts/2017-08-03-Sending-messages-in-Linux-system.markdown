---
layout:     post
title:      "linux用户间发送消息"
subtitle:   "Sending messages in Linux system"
date:       2017-08-03
author:     "QQF"
header-img: "img/home-bg.png"
catalog: true
tags:
    - Linux系统运维与服务器管理
    - 我的笔记
---

# wall命令
这个命令的功能是对全部已登录的用户发送信息，用户可以先把要发送的信息写好存入一个文件中，然后输入：`wall < 文件名`，这样就能对所有的用户发送信息了。
在上面的例子中符号“<”表示输入重定向，例如：
`wall 'Thank you!'` 

```
Broadcast message from root （tty1） Fri Nov 26 14：15：07 1999…
Thank you!
```

执行以上命令后，用户的屏幕上显示出“Thank you!”信息后，并不出现系统提示符$（#），再次按回车键后，屏幕出现系统提示符。

# write命令

write命令的功能是向系统中某一个用户发送信息。 该命令的一般格式为：

`write 用户帐号 [终端名称]` 

例如： `$ write Guest` 

此时系统进入发送信息状态，用户可以输入要发送的信息，输入完毕，希望退出发送状态时，按组合键< Ctrl+c>即可。

# mesg指令

mesg命令设定是否允许其他用户用write或wall命令给自己发送信息，但是管理员可以给任何人发信息。如果允许别人给自己发送信息，输入命令：

`mesg y`

否则，输入：

`mesg n`

对于超级用户，系统的默认值为n；而对于一般用户系统的默认值为y。