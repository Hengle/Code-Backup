使用print输出各型的字符串，整数，浮点数，出度及精度控制 

1.格式化输出整数 
==========

python print也支持参数格式化，与C言的printf似， 

```
strHello = "the length of (%s) is %d" %('Hello World',len('Hello World'))

print strHello

#输出果：the length of (Hello World) is 11
```

2.格式化输出16制整数
============

```
nHex = 0x20

#%x --- hex 十六进制

#%d --- dec 十进制

#%d --- oct 八进制

print "nHex = %x,nDec = %d,nOct = %o" %(nHex,nHex,nHex)

#输出结果：nHex = 20,nDec = 32,nOct = 40

#使用整数的各个制打印同一个数
```

3.格式化输出浮点数(float)
=================

```
import math

#default

print "PI = %f" % math.pi

#width = 10,precise = 3,align = left

print "PI = %10.3f" % math.pi

#width = 10,precise = 3,align = rigth

print "PI = %-10.3f" % math.pi

#前面填充字符

print "PI = %06d" % int(math.pi)

#输出结果

#PI = 3.141593

#PI = 3.142

#PI = 3.142

#PI = 000003

#浮点数的格式化，精度
```

4.格式化输出字符串(string)
==================

```
#precise = 3

print "%.3s " % ("jcodeer")

#precise = 4

print "%.*s" % (4,"jcodeer")

#width = 10,precise = 3

print "%10.3s" % ("jcodeer")

#输出结果：

#jco

#jcod

# jco

#同于字符串也存在精度、度和。
```

5.输出列表(list)
============

```
l = [1,2,3,4,'jcodeer']

print l

#输出结果：[1, 2, 3, 4, 'jcodeer']

#于list直接打印即可

'''6.出字典(dictionary)'''

d = {1:'A',2:'B',3:'C',4:'D'}

print d

#输出结果：{1: 'A', 2: 'B', 3: 'C', 4: 'D'}

#同python也是支持dictionary出的
```

6.python print自动换行
==================

print 会自动在行末加上回车,如果不需回车，只需在print语句的结尾添加一个逗号”,“，就可以改变它的行为。 

```
for i in range(0,5):

 print i,
```

或直接使用下面的函数进行输出：

```
sys.stdout.write("输出的字串")
```

7\. 万能的 %r 
===========

有个同事问我python里面print ”%r” 是什么用途，被问倒了。 

用了这么些年的python，还没用过print %r。 

网上查了一下，发现%r是一个万能的格式付，它会将后面给的参数原样打印出来，带有类型信息。 

python print %r 案例 

```
formatter = "%r %r %r %r"

print formatter % (1, 2, 3, 4)

print formatter % ("one", "two", "three", "four")

print formatter % (True, False, False, True)

print formatter % (formatter, formatter, formatter, formatter)

print formatter % (

"I had this thing.",

"That you could type up right.",

"But it didn't sing.",

"So I said goodnight."

)
```

输出结果：

```
$ python ex8.py

1 2 3 4

'one' 'two' 'three' 'four'

True False False True

'%r %r %r %r' '%r %r %r %r' '%r %r %r %r' '%r %r %r %r'

'I had this thing.' 'That you could type up right.' "But it didn't sing." 'So I said goodnight.'

$
```

