---
layout:     post
title:      "linux自定义登录提示信息"
subtitle:   "Linux login information"
date:       2017-08-24
author:     "QQF"
header-img: "img/home-bg.png"
catalog: false
tags:
    - Linux系统运维与服务器管理
    - 我的笔记
---

其实想设置提示信息很简单，我们只需要修改/etc/motd文件。我们先看一眼这个文件，执行命令：`cat /etc/motd`，发现里边是空的。


接下来让我们编辑一下这个文件，写入我们想要提示的东西。如NFS挂载信息、静态路由信息，允许用户打开的最大文件数、集群信息等。命令：`vi /etc/motd`，编辑完成后，保存退出。命令`：wq`

接下来让我们验证一下，退出终端后重新连接，发现此时我们添加的内容已经出现在登录首页！