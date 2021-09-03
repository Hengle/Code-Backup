# Linux使用video dummy

有时候linux电脑没有显示器，但是有时候会必须要有显示输出设备。因此，可以使用video dummy替代

编辑dummy.config文件，输入下面这些内容：

```
Section "Monitor"
  Identifier "Monitor0"
  HorizSync 28.0-80.0
  VertRefresh 48.0-75.0
  # https://arachnoid.com/modelines/
  # 1920x1080 @ 60.00 Hz (GTF) hsync: 67.08 kHz; pclk: 172.80 MHz
  Modeline "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync
EndSection

Section "Device"
  Identifier "Card0"
  Driver "dummy"
  VideoRam 256000
EndSection

Section "Screen"
  DefaultDepth 24
  Identifier "Screen0"
  Device "Card0"
  Monitor "Monitor0"
  SubSection "Display"
    Depth 24
    Modes "1920x1080_60.00"
  EndSubSection
EndSection
```

然后打开一个terminal，运行：

```shell
sudo X -config dummy.config
```

可以看到terminal显示出类似这样的信息并停住：

```
X.Org X Server 1.19.6
Release Date: 2017-12-20
X Protocol Version 11, Revision 0
Build Operating System: Linux 4.4.0-138-generic x86_64 Ubuntu
Current Operating System: Linux ubuntu-s-1vcpu-2gb-fra1-01 4.15.0-45-generic #48-Ubuntu SMP Tue Jan 29 16:28:13 UTC 2019 x86_64
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.15.0-45-generic root=LABEL=cloudimg-rootfs ro console=tty1 console=ttyS0
Build Date: 25 October 2018  04:11:27PM
xorg-server 2:1.19.6-1ubuntu4.2 (For technical support please see http://www.ubuntu.com/support) 
Current version of pixman: 0.34.0
        Before reporting problems, check http://wiki.x.org
        to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
        (++) from command line, (!!) notice, (II) informational,
        (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sat Feb 23 17:48:07 2019
(++) Using config file: "dummy-1920x1080.conf"
(==) Using system config directory "/usr/share/X11/xorg.conf.d"
```

注意看，上面有一行“(==) Log file: "/var/log/Xorg.0.log", Time: Sat Feb 23 17:48:07 2019”，说明此时的虚拟显示设备是0号设备。

另外打开一个terminal，设置显示环境变量

```
export DISPLAY=:0
```

然后就可以正常运行那些需要显示输出的程序了，虽然啥东西都不会输出出来。很方便

