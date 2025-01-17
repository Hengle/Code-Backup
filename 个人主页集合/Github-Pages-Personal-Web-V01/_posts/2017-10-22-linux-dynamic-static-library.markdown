---
layout:     post
title:      "Linux系统中“动态库”和“静态库”那点事儿"
subtitle:   "Linux dynamic and static library"
date:       2017-10-22
author:     "QQF"
header-img: "img/home-bg.png"
catalog: false
tags:
    - Linux系统运维与服务器管理
---

今天我们主要来说说Linux系统下基于动态库(.so)和静态(.a)的程序那些猫腻。在这之前，我们需要了解一下源代码到可执行程序之间到底发生了什么神奇而美妙的事情。


在Linux操作系统中，普遍使用ELF格式作为可执行程序或者程序生成过程中的中间格式。ELF（Executable and Linking Format，可执行连接格式）是UNIX系统实验室（USL）作为应用程序二进制接口（Application BinaryInterface，ABI）而开发和发布的。工具接口标准委员会（TIS）选择了正在发展中的ELF标准作为工作在32位Intel体系上不同操作系统之间可移植的二进制文件格式。本文不对ELF文件格式及其组成做太多解释，以免冲淡本文的主题，大家只要知道这么个概念就行。以后再详解Linux中的ELF格式。源代码到可执行程序的转换时需要经历如下图所示的过程：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/01.png)

* 编译是指把用高级语言编写的程序转换成相应处理器的汇编语言程序的过程。从本质上讲，编译是一个文本转换的过程。对嵌入式系统而言，一般要把用C语言编写的程序转换成处理器的汇编代码。编译过程包含了C语言的语法解析和汇编码的生成两个步骤。编译一般是逐个文件进行的，对于每一个C语言编写的文件，可能还需要进行预处理。



* 汇编是从汇编语言程序生成目标系统的二进制代码（机器代码）的过程。机器代码的生成和处理器有密切的联系。相对于编译过程的语法解析，汇编的过程相对简单。这是因为对于一款特定的处理器，其汇编语言和二进制的机器代码是一一对应的。汇编过程的输入是汇编代码，这个汇编代码可能来源于编译过程的输出，也可以是直接用汇编语言书写的程序。


* 连接是指将汇编生成的多段机器代码组合成一个可执行程序。一般来说，通过编译和汇编过程，每一个源文件将生成一个目标文件。连接器的作用就是将这些目标文件组合起来，组合的过程包括了代码段、数据段等部分的合并，以及添加相应的文件头。

GCC是Linux下主要的程序生成工具，它除了编译器、汇编器、连接器外，还包括一些辅助工具。在下面的分析过程中我会教大家这些工具的基本使用方法，Linux的强大之处在于，对于不太懂的命令或函数，有一个很强大的“男人”时刻stand by your side，有什么不会的就去命令行终端输入：man [命令名或函数名]，然后阿拉神灯就会显灵了。


对于最后编译出来的可执行程序，当我们执行它的时候，操作系统又是如何反应的呢？我们先从宏观上来个总体把握，如图2所示：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/02.png)

作为UNIX操作系统的一种，Linux的操作系统提供了一系列的接口，这些接口被称为系统调用（System Call）。在UNIX的理念中，系统调用“提供的是机制，而不是策略“。C语言的库函数通过调用系统调用来实现，库函数对上层提供了C语言库文件的接口。在应用程序层，通过调用C语言库函数和系统调用来实现功能。一般来说，应用程序大多使用C语言库函数实现其功能，较少使用系统调用。


那么最后的可执行文件到底是什么样子呢？前面已经说过，这里我们不深入分析ELF文件的格式，只是给出它的一个结构图和一些简单的说明，以方便大家理解。


ELF文件格式包括三种主要的类型：可执行文件、可重定向文件、共享库。


1．可执行文件（应用程序）


可执行文件包含了代码和数据，是可以直接运行的程序。


2．可重定向文件（\*.o）


可重定向文件又称为目标文件，它包含了代码和数据（这些数据是和其他重定位文件和共享的object文件一起连接时使用的）。


\*.o文件参与程序的连接（创建一个程序）和程序的执行（运行一个程序），它提供了一个方便有效的方法来用并行的视角看待文件的内容，这些*.o文件的活动可以反映出不同的需要。


Linux下，我们可以用gcc -c编译源文件时可将其编译成*.o格式。


3．共享文件（\*.so）


也称为动态库文件，它包含了代码和数据（这些数据是在连接时候被连接器ld和运行时动态连接器使用的）。动态连接器可能称为ld.so.1，libc.so.1或者 ld-linux.so.1。我的CentOS6.0系统中该文件为：/lib/ld-2.12.so


![img](/img/in-post/2017-10-22-linux-dynamic-static-library/03.png)

一个ELF文件从连接器（Linker）的角度看，是一些节的集合；从程序加载器（Loader）的角度看，它是一些段（Segments）的集合。ELF格式的程序和共享库具有相同的结构，只是段的集合和节的集合上有些不同。


那么到底什么是库呢？


库从本质上来说是一种可执行代码的二进制格式，可以被载入内存中执行。库分静态库和动态库两种。


静态库：这类库的名字一般是libxxx.a，xxx为库的名字。利用静态函数库编译成的文件比较大，因为整个函数库的所有数据都会被整合进目标代码中，他的优点就显而易见了，即编译后的执行程序不需要外部的函数库支持，因为所有使用的函数都已经被编译进去了。当然这也会成为他的缺点，因为如果静态函数库改变了，那么你的程序必须重新编译。


动态库：这类库的名字一般是libxxx.M.N.so，同样的xxx为库的名字，M是库的主版本号，N是库的副版本号。当然也可以不要版本号，但名字必须有。相对于静态函数库，动态函数库在编译的时候并没有被编译进目标代码中，你的程序执行到相关函数时才调用该函数库里的相应函数，因此动态函数库所产生的可执行文件比较小。由于函数库没有被整合进你的程序，而是程序运行时动态的申请并调用，所以程序的运行环境中必须提供相应的库。动态函数库的改变并不影响你的程序，所以动态函数库的升级比较方便。linux系统有几个重要的目录存放相应的函数库，如/lib /usr/lib。


当要使用静态的程序库时，连接器会找出程序所需的函数，然后将它们拷贝到执行文件，由于这种拷贝是完整的，所以一旦连接成功，静态程序库也就不再需要了。然而，对动态库而言，就不是这样。动态库会在执行程序内留下一个标记指明当程序执行时，首先必须载入这个库。由于动态库节省空间，linux下进行连接的缺省操作是首先连接动态库，也就是说，如果同时存在静态和动态库，不特别指定的话，将与动态库相连接。


OK,有了这些知识，接下来大家就可以弄明白我所做的事情是干什么了。都说例子是最好老师，我们就从例子入手。


1、静态链接库


我们先制作自己的静态链接库，然后再使用它。制作静态链接库的过程中要用到gcc和ar命令。


准备两个库的源码文件st1.c和st2.c，用它们来制作库libmytest.a，如下：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/04.png)

静态库文件libmytest.a已经生成，用file命令查看其属性，发现它确实是归档压缩文件。用ar -t libmytest.a可以查看一个静态库包含了那些obj文件：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/05.png)

接下来我们就写个测试程序来调用库libmytest.a中所提供的两个接口print1()和print2()。

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/06.png)

看到没，静态库的编写和调用就这么简单，学会了吧。这里gcc的参数-L是告诉编译器库文件的路径是当前目录，-l是告诉编译器要使用的库的名字叫mytest。


2、动态库


静态库*.a文件的存在主要是为了支持较老的a.out格式的可执行文件而存在的。目前用的最多的要数动态库了。


动态库的后缀为*.so。在Linux发行版中大多数的动态库基本都位于/usr/lib和/lib目录下。在开发和使用我们自己动态库之前，请容许我先落里罗嗦的跟大家唠叨唠叨Linux下和动态库相关的事儿吧。


有时候当我们的应用程序无法运行时，它会提示我们说它找不到什么样的库，或者哪个库的版本又不合它胃口了等等之类的话。那么应用程序它是怎么知道需要哪些库的呢？我们前面已几个学了个很棒的命令ldd，用就是用来查看一个文件到底依赖了那些so库文件。


Linux系统中动态链接库的配置文件一般在/etc/ld.so.conf文件内，它里面存放的内容是可以被Linux共享的动态联库所在的目录的名字。我的系统中，该文件的内容如下：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/07.png)

然后/etc/ld.so.conf.d/目录下存放了很多*.conf文件，如下：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/08.png)

其中每个conf文件代表了一种应用的库配置内容，以mysql为例：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/09.png)

如果您是和我一样装的CentOS6.0的系统，那么细心的读者可能会发现，在/etc目录下还存在一个名叫ld.so.cache的文件。从名字来看，我们知道它肯定是动态链接库的什么缓存文件。


对，您说的一点没错。为了使得动态链接库可以被系统使用，当我们修改了/etc/ld.so.conf或/etc/ld.so.conf.d/目录下的任何文件，或者往那些目录下拷贝了新的动态链接库文件时，都需要运行一个很重要的命令：ldconfig，该命令位于/sbin目录下，主要的用途就是负责搜索/lib和/usr/lib，以及配置文件/etc/ld.so.conf里所列的目录下搜索可用的动态链接库文件，然后创建处动态加载程序/lib/ld-linux.so.2所需要的连接和(默认)缓存文件/etc/ld.so.cache(此文件里保存着已经排好序的动态链接库名字列表)。


也就是说：当用户在某个目录下面创建或拷贝了一个动态链接库，若想使其被系统共享，可以执行一下“ldconfig目录名“这个命令。此命令的功能在于让ldconfig将指定目录下的动态链接库被系统共享起来，即：在缓存文件/etc/ld.so.cache中追加进指定目录下的共享库。请注意：如果此目录不在/lib,/usr/lib及/etc/ld.so.conf文件所列的目录里面，则再次单独运行ldconfig时，此目录下的动态链接库可能不被系统共享了。单独运行ldconfig时，它只会搜索/lib、/usr/lib以及在/etc/ld.so.conf文件里所列的目录，用它们来重建/etc/ld.so.cache。


因此，等会儿我们自己开发的共享库就可以将其拷贝到/lib、/etc/lib目录里，又或者修改/etc/ld.so.conf文件将我们自己的库路径添加到该文件中，再执行ldconfig命令。


非了老半天功夫，终于把基础打好了，猴急的您早已按耐不住激情的想动手尝试了吧！哈哈。。。OK，说整咱就开整，接下来我就带领大家一步一步来开发自己的动态库，然后教大家怎么去使用它。


我们有一个头文件my_so_test.h和三个源文件test_a.c、test_b.c和test_c.c，将他们制作成一个名为libtest.so的动态链接库文件：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/10.png)

OK，万事俱备，只欠东风。如何将这些文件编译成一个我们所需要的so文件呢？可以分两步来完成，也可以一步到位：


方法一：

1、先生成目标.o文件：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/11.png)

2、再生成so文件：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/12.png)

-shared该选项指定生成动态连接库（让连接器生成T类型的导出符号表，有时候也生成弱连接W类型的导出符号），不用该标志外部程序无法连接。相当于一个可执行文件。


-fPIC：表示编译为位置独立的代码，不用此选项的话编译后的代码是位置相关的所以动态载入时是通过代码拷贝的方式来满足不同进程的需要，而不能达到真正代码段共享的目的。


方法二：一步到位。

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/13.png)

至此，我们制作的动态库文件libtest.so就算大功告成了。
接下来，就是如何使用这个动态库了。动态链接库的使用有两种方法：既可以在运行时对其进行动态链接，又可以动态加载在程序中是用它们。接下来，我就这两种方法分别对其介绍。


+++动态库的使用+++



用法一：动态链接。

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/14.png)

使用“-ltest”标记来告诉GCC驱动程序在连接阶段引用共享函数库libtest.so。“-L.”标记告诉GCC函数库可能位于当前目录。否则GNU连接器会查找标准系统函数目录。


这里我们注意，ldd的输出它说我们的libtest.so它没找到。还记得我在前面动态链接库一节刚开始时的那堆唠叨么，现在你应该很明白了为什么了吧。因为我们的libtest.so既不在/etc/ld.so.cache里，又不在/lib、/usr/lib或/etc/ld.so.conf所指定的任何一个目录中。怎么办？还用我告诉你？管你用啥办法，反正我用的ldconfig pwd搞定的：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/15.png)

执行结果如下：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/16.png)

偶忍不住又要罗嗦一句了，相信俺，我的唠叨对大家是有好处。我为什么用这种方法呢？因为我是在给大家演示动态库的用法，完了之后我就把libtest.so给删了，然后再重构ld.so.cache，对我的系统不会任何影响。倘若我是开发一款软件，或者给自己的系统DIY一个非常有用的功能模块，那么我更倾向于将libtest.so拷贝到/lib、/usr/lib目录下，或者我还有可能在/usr/local/lib/目录下新建一文件夹xxx，将so库拷贝到那儿去，并在/etc/ld.so.conf.d/目录下新建一文件mytest.conf，内容只有一行“/usr/local/lib/xxx/libtest.so”，再执行ldconfig。如果你之前还是不明白怎么解决那个“not found”的问题，那么现在总该明白了吧。


方法二：动态加载。


动态加载是非常灵活的，它依赖于一套Linux提供的标准API来完成。在源程序里，你可以很自如的运用API来加载、使用、释放so库资源。以下函数在代码中使用需要包含头文件：dlfcn.h

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/17.png)

dlsym(void \*handle, char \*symbol)
filename:如果名字不以“/”开头，则非绝对路径名，将按下列先后顺序查找该文件。


（1）用户环境变量中的LD_LIBRARY值；

（2）动态链接缓冲文件/etc/ld.so.cache

（3）目录/lib,/usr/lib


flag表示在什么时候解决未定义的符号（调用）。取值有两个：


1） RTLD_LAZY : 表明在动态链接库的函数代码执行时解决。

2） RTLD_NOW :表明在dlopen返回前就解决所有未定义的符号，一旦未解决，dlopen将返回错误。


```
dlsym(void *handle, char *symbol)
```

dlsym()的用法一般如下：

```
void（*add）（int x,int y）； /*说明一下要调用的动态函数add */
add=dlsym（"xxx.so","add"）； /* 打开xxx.so共享库，取add函数地址 */
add（89,369）； /* 带两个参数89和369调用add函数 */
```

看我出招：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/18.png)

执行结果：

![img](/img/in-post/2017-10-22-linux-dynamic-static-library/19.png)

使用动态链接库，源程序中要包含dlfcn.h头文件，写程序时注意dlopen等函数的正确调用，编译时要采用-rdynamic选项与-ldl选项(不然编译无法通过)，以产生可调用动态链接库的执行代码。


OK，通过本文的指导、练习相信各位应该对Linux的库机制有了些许了解，最主要的是会开发使用库文件了。由于本人知识所限，文中某些观点如果不到位或理解有误的地方还请各位个人不吝赐教。
