---
layout:     post
title:      "lsb_release查询系统版本"
subtitle:   "Getting system version using lsb_release"
date:       2017-08-03
author:     "QQF"
header-img: "img/home-bg.png"
catalog: false
tags:
    - Linux系统运维与服务器管理
    - 我的笔记
---

LSB是Linux Standard Base的缩写，lsb_release命令用来显示LSB和特定版本的相关信息。如果使用该命令时不带参数，则默认加上-v参数。

-v, --version
显示版本信息

-i, --id
显示发行版的ID

-d, --description
显示该发行版的描述信息

-r, --release
显示当前系统是发行版的具体版本号

-c, --codename
发行版代号

-a, --all
显示上面的所有信息

-h, --help
显示帮助信息

如果当前发行版是LSB兼容的，那么“/etc/lsb_release”文件中会包含LSB_VERSION域。这个域的值可以是用冒号隔开的一系列支持的模块。这些模块名是当前版本支持的LSB的模块名。如果当前版本不是LSB兼容的，就不要包含这个域。

可选的域包括DISTRIB_ID, DISTRIB_RELEASE, DISTRIB_CODENAME, DISTRIB_DESCRIPTION，它们可以覆盖/etc/distrib-release文件中的内容。注：这里的distrib要替换为当前的发行版的名字。

如果存在/etc/lsb-release.d目录，会在该目录中查找文件名并作为附加的模块版本加在LSB_VERSION前面。文件/etc/distrib-release中包含了一些描述信息，用来说明应该分析哪些文件名。一般的格式是："Distributor release x.x (Codename)"
注意：Debian系统中缺乏相应的描述信息（见/etc/debian-version），为了支持Debian系统，大部分信息都被加在了lsb-release文件中。

redhat和fedora系统中，还支持一个参数：
-s, --short 
输出简短的描述信息