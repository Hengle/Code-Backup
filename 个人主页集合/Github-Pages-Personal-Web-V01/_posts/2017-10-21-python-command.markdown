---
layout:     post
title:      "Python 开发命令行工具"
subtitle:   "Python develop a command line tool"
date:       2017-10-21
author:     "QQF"
header-img: "img/home-bg.png"
catalog: true
tags:
    - Python
---

Python 作为一种脚本语言，可以非常方便地用于系统（尤其是*nix系统）命令行工具的开发。Python 自身也集成了一些标准库，专门用于处理命令行相关的问题。

# 命令行工具的一般结构

![img](/img/in-post/2017-10-21-python-command/01.png)

## 1. 标准输入输出

\*nix 系统中，一切皆为文件，因此标准输入、输出可以完全可以看做是对文件的操作。标准化输入可以通过管道（pipe）或重定向（redirect）的方式传递：

```
# script reverse.py
#!/usr/bin/env python
import sys
for l in sys.stdin.readlines():
    sys.stdout.write(l[::-1])
```

保存为 reverse.py，通过管道 \| 传递：

```
chmod +x reverse.py
cat reverse.py | ./reverse.py

nohtyp vne/nib/rsu/!#
sys tropmi
:)(senildaer.nidts.sys ni l rof
)]1-::[l(etirw.tuodts.sys
```

通过重定向 传递：

```
./reverse.py  reverse.py
# 输出结果同上
```

## 2. 命令行参数

一般在命令行后追加的参数可以通过 sys.argv 获取， sys.argv 是一个列表，其中第一个元素为当前脚本的文件名：

```
# script argv.py
#!/usr/bin/env python
import sys
print(sys.argv) # 下面返回的是 Jupyter 运行的结果
```

```
['/Users/rainy/Projects/GitHub/pytips/venv3/lib/python3.5/site-packages/ipykernel/__main__.py', '-f', '/Users/rainy/Library/Jupyter/runtime/kernel-0533e681-bd7c-4c4d-9094-a78fde7fc2ed.json']
```

运行上面的脚本：

```
chmod +x argv.py
./argv.py hello world
python argv.py hello world

# 返回的结果是相同的
# ['./test.py', 'hello', 'world']
```

对于比较复杂的命令行参数，例如通过 --option 传递的选项参数，如果是对 sys.argv 逐项进行解析会很麻烦，Python 提供标准库 argparse（旧的库为 optparse，已经停止维护）专门解析命令行参数：

```
# script convert.py
#!/usr/bin/env python
import argparse as apa
def loadConfig(config):
    print("Load config from: {}".format(config))
def setTheme(theme):
    print("Set theme: {}".format(theme))
def main():
    parser = apa.ArgumentParser(prog="convert") # 设定命令信息，用于输出帮助信息
    parser.add_argument("-c", "--config", required=False, default="config.ini")
    parser.add_argument("-t", "--theme", required=False, default="default.theme")
    parser.add_argument("-f") # Accept Jupyter runtime option
    args = parser.parse_args()
    loadConfig(args.config)
    setTheme(args.theme)

if __name__ == "__main__":
    main()
```

```
Load config from: config.ini
Set theme: default.theme
```

利用 argparse 可以很方便地解析选项参数，同时可以定义指定参数的相关属性（是否必须、默认值等），同时还可以自动生成帮助文档。执行上面的脚本：

```
./convert.py -h
usage: convert [-h] [-c CONFIG] [-t THEME]

optional arguments:
  -h, --help            show this help message and exit
  -c CONFIG, --config CONFIG
  -t THEME, --theme THEME
```

## 3. 执行系统命令

当 Python 能够准确地解读输入信息或参数之后，就可以通过 Python 去做任何事情了。这里主要介绍通过 Python 调用系统命令，也就是替代 Shell 脚本完成系统管理的功能。我以前的习惯是将命令行指令通过 os.system(command) 执行，但是更好的做法应该是用 subprocess 标准库，它的存在就是为了替代旧的 os.system; os.spawn* 。

subprocess 模块提供简便的直接调用系统指令的call()方法，以及较为复杂可以让用户更加深入地与系统命令进行交互的Popen对象。

```
# script list_files.py
#!/usr/bin/env python
import subprocess as sb
res = sb.check_output("ls -lh ./*.ipynb", shell=True) # 为了安全起见，默认不通过系统 Shell 执行，因此需要设定 shell=True
print(res.decode()) # 默认返回值为 bytes 类型，需要进行解码操作
```

```
-rw-r--r--  1 rainy  staff   3.4K  3  8 17:36 ./2016-03-06-The-Zen-of-Python.ipynb
-rw-r--r--  1 rainy  staff   6.7K  3  8 17:45 ./2016-03-07-iterator-and-generator.ipynb
-rw-r--r--  1 rainy  staff   6.0K  3 10 12:35 ./2016-03-08-Functional-Programming-in-Python.ipynb
-rw-r--r--  1 rainy  staff   5.9K  3  9 16:28 ./2016-03-09-List-Comprehension.ipynb
-rw-r--r--  1 rainy  staff    10K  3 10 14:14 ./2016-03-10-Scope-and-Closure.ipynb
-rw-r--r--  1 rainy  staff   8.0K  3 11 16:30 ./2016-03-11-Arguments-and-Unpacking.ipynb
-rw-r--r--  1 rainy  staff   8.5K  3 14 19:31 ./2016-03-14-Command-Line-tools-in-Python.ipynb
```

如果只是简单地执行系统命令还不能满足你的需求，可以使用 subprocess.Popen 与生成的子进程进行更多交互：

```
import subprocess as sb

p = sb.Popen(['grep', 'communicate'], stdin=sb.PIPE, stdout=sb.PIPE)
res, err = p.communicate(sb.check_output('cat ./*', shell=True))
if not err:
    print(res.decode())
```

```
"    "p = sb.Popen(['grep', 'communicate'], stdout=sb.PIPE)\n",n",
"    "# res = p.communicate(sb.check_output('cat ./*'))"n",
"p = sb.Popen(['grep', 'communicate'], stdin=sb.PIPE, stdout=sb.PIPE)n",

"res, err = p.communicate(sb.check_output('cat ./*', shell=True))n",
```
