我们在数值模式编译的时候，可以注意到有很多的目标文件、库文件、头文件以及最终的可执行文件需要编译。这些文件之间存在很强的依赖关系。这里举个简单的例子： 

```shell
$gcc -c -o test.o test.c 

$gcc -o helloworld test.o 
```

可执行文件helloworld依赖于test.o进行编译的，而test.o依赖于test.c。 

在数值模式里，我们编译的时候，需要先编译各种参数化方案的代码，最后再整合到同一个可执行文件之中，这就需要自下而上进行编译。 

UNIX系统下的make工具用于自动记录和处理文件之间的依赖关系。所有的依赖关系都记录在makefile文本文件中。我们只需要make helloworld，make会根据依赖关系，自上而下的找到编译该文件所需的所有依赖关系，最后再自下而上的编译。 

基本概念 
-----

我们使用一个示例C语言文件: 

```c
#include <stdio.h> 

int main() 

{

printf("Hello world!\n");

return 0; 

}
```

下面是一个简单的makefile: 

```shell
# helloworld is a binary file

helloworld: test.o 

gcc -o helloworld test.o 

test.o: test.c 

gcc -c -o test.o test.c 
```

上面的例子里： 

* \#号起始的行是注释行
* target: prerequisite（比如例子里的test.o: test.c）为依赖关系，即目标文件(target)依赖于前提文件(prerequisite)。可以有多个前提文件，用空格分开。
* 依赖关系后面的缩进行是实现依赖关系进行的操作，即正常的UNIX命令。一个依赖关系可以附属有多个操作。

有了这个makefile，我们就可以这样: 

$make helloworld 

命令执行后就可以得到编译的二进制文件helloworld。 

make是一个递归创建的过程: 

* 如果当前依赖关系中没有说明前提文件，那么直接执行操作。
* 如果当前依赖关系说明了目标文件，而目标文件所需的前提文件已经存在，而且前提文件与上次make时没有发生改变(根据最近写入时间判断)，也直接执行该依赖关系的操作。
* 如果当前目标文件依赖关系所需的前提文件不存在，或者前提文件发生改变，那么以前提文件为新的目标文件，寻找依赖关系，创建目标文件。

宏 
--

make中可以使用宏。比如下面的CC: 

```c
CC = gcc 

# helloworld is a binary file

helloworld: test.o 

$(CC) -o helloworld test.o 

test.o: test.c 

$(CC) -c -o test.o test.c 
```

这里的CC的值为"gcc"。在makefile中，使用$(CC)的方式来调用宏的值。make会在运行时，使用宏的值gcc来替代$(CC)。 

shell的环境变量可以直接作为宏调用。如果同一个自定义的宏同时也有同名环境环境变量，make将优先使用自定义宏(可以使用$make -e helloworld来优先使用环境变量)。 

和C语言一样，宏可以用于替代一些重复出现的代码。比如以后更换编译器，只需要调整CC的值就可以了，例如把GNU的编译器换成Intel的编译器，只需要CC = icc就可以了。 

内部宏 
----

make中有内部定义的宏，可以直接使用。\$@中包含有当前依赖关系的目标文件名，而$^包含当前目标的前提文件: 

```shell
CC = gcc 

# helloworld is a binary file

helloworld: test.o 

echo $@ 

(CC) -o @ $^ 

test.o: test.c 

(CC) -c -o @ $^ 
```

内部宏的功能: 

\$? ：比目标的修改时间更晚的那些依赖模块表。

\$@ ：当前目标的全路径名。可用于用户定义的目标名的相关行中。

\$\< ：比给定的目标文件时间标记更新的依赖文件名。

\$\* ：去掉后缀的当前目标名。例如，若当前目标是pro.o，则\$\*表示pro。 

如果目标或者前提文件是一个完整路径，我们可以附加D和F来提取文件夹部分和文件名部分，比如\$(@F)表示目标文件的文件名部分。 

后缀依赖 
-----

在makefile中使用.SUFFIXES: .c .o来说明.c和.o是后缀。我们可以使用后缀依赖的方式，比如: 

```shell
CC = gcc 

.SUFFIXES: .c .o 

.c.o:

(CC) -c -o @ $^ 

#--------------------------

# helloworld is a binary file

helloworld: test.o 

echo $@ 

(CC) -o @ $^ 

test.o: test.c 
```

我们定义.c和.o为后缀。并有后缀依赖关系.c.o:。前者为前提，后者为目标。(注意，与一般的依赖关系顺序不同) 

上面的test.o和test.c有依赖关系，但没有操作。make会发现该依赖关系符合.c.o的后缀依赖，并执行该后缀依赖后面的操作。 

如果项目很大型的时候，后缀依赖非常有用。符合后缀依赖的文件往往有类似的操作，我们可以将这些操作用后缀依赖表示，而避免重复输入。 

其他 
---

makefile的续行符为 / 

makefile中经常会定义下面依赖关系: 

all: 如果make后没有跟随文件名，那么将执行该依赖关系。 

clean: 常用于清理历史文件。 

比如: 

```shell
CC = gcc 

.SUFFIXES: .c .o 

.c.o:

(CC) -c -o @ $^ 

#--------------------------

all: helloworld 

@echo "ALL" 

# helloworld is a binary file

helloworld: test.o 

@echo $@ 

(CC) -o @ $^ 

test.o: test.c 

clean:

-rm helloworld *.o 
```

注意: echo前面的@和rm前面的-。@后的命令将不显示命令本身。-后面的命令将忽略错误(比如删除不存在的文件)。 

上面这个例子还可以写成另外一种形式： 

```shell
CC = gcc 

.SUFFIXES: .c .o 

.c.o:

(CC) -c -o @ $^ 

#--------------------------

all: helloworld 

@echo "ALL" 

# helloworld is a binary file

helloworld: test.o 

@echo $@ 

(CC) -o @ $^ 

test.o: test.c 

.PHONY : clean 

clean:

-rm helloworld *.o 
```

“.PHONY”表示，clean是个伪目标文件。 

变量替换 
-----

我们可以替换变量中的共有的部分，其格式是“(var:a=b)”或是“{var:a=b}”，其意思是，把变量“var”中所有以“a”字串“结尾”的“a”替换成“b”字串。这里的“结尾”意思是“空格”或是“结束符”。 

```shell
foo := a.o b.o c.o 

bar := $(foo:.o=.c) 
```

这个示例中，我们先定义了一个“(foo)”变量，而第二行的意思是把“(foo)”中所有以“.o”字串“结尾”全部替换成“.c”，所以我们的“$(bar)”的值就是“a.c b.c c.c”。