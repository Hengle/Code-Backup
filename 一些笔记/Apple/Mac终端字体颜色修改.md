bash\_profile配置 
----------------

```shell
export LS_OPTIONS='--color=auto' # 如果没有指定，则自动选择颜色

export CLICOLOR='Yes' #是否输出颜色

export LSCOLORS='CxfxcxdxbxegedabagGxGx' #指定颜色
```

其中，LSCOLORS中的意思是这样的：22个字母2个字母一组分别指定一种类型的文件或者文件夹显示的字体颜色和背景颜色。从第1组到第11组分别指定的文件或文件类型为：

directory

symbolic link

socket

pipe

executable

block special

character special

executable with setuid bit set

executable with setgid bit set

directory writable to others, with sticky bit

directory writable to others, without sticky bit

下面是对应的颜色：

a 黑色

b 红色

c 绿色

d 棕色

e 蓝色

f 洋红色

g 青色

h 浅灰色

A 黑色粗体

B 红色粗体

C 绿色粗体

D 棕色粗体

E 蓝色粗体

F 洋红色粗体

G 青色粗体

H 浅灰色粗体

x 系统默认颜色 

改变PS1的颜色 
---------

在PS1中配置字符序列颜色的格式为：\\[\\e[F;Bm\\]

基本上是夹在 "\\e["（转义开方括号）和 "m" 之间数字值。假如指定一个以上的数字代码，则用分号将他们分开。其中 F 为字体颜色，编号30~37； B 为背景色，编号40~47。可通过 \\e[0m 关闭颜色输出；特别的，当B为1时，将显示加亮加粗的文字，请看下面的颜色表和代码表。 

颜色表 

前景 背景 颜色

---------------------------------------

30 40 黑色

31 41 红色

32 42 绿色

33 43 黄色

34 44 蓝色

35 45 紫色

36 46 青色

37 47 白色

代码 意义

-------------------------

0 OFF

1 高亮显示

4 underline

5 闪烁

7 反白显示

8 不可见