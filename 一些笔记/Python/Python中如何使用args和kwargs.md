或者可以叫做，在Python中如何使用可变长参数列表

函数定义 
=====

这是一种特殊的语法，在函数定义中使用\*args和kwargs传递可变长参数. \*args用作传递非命名键值可变长参数列表（位置参数）; kwargs用作传递键值可变长参数列表 

下面的例子传递一个位置参数以及两个可变长参数 

```
def test_var_args(farg, *args):

 print "formal arg:", farg

 for arg in args:

 print "another arg:", arg

test_var_args(1, "two", 3)
```

结果:

```
formal arg: 1

another arg: two

another arg: 3
```

这里有一个键值的例子，传递一个位置参数和两个键值参数

```
def test_var_kwargs(farg, **kwargs):

 print "formal arg:", farg

 for key in kwargs:

 print "another keyword arg: %s: %s" % (key, kwargs[key])

test_var_kwargs(farg=1, myarg2="two", myarg3=3)
```

结果:

```
formal arg: 1

another keyword arg: myarg2: two

another keyword arg: myarg3: 3
```

函数调用 
=====

这种语法不仅在函数定义中可以使用，在调用函数是也会出现 

(相当于extract package的效果) 

在调用函数时，使用args和\*kwargs 

```
def test_var_args_call(arg1, arg2, arg3):

 print "arg1:", arg1

 print "arg2:", arg2

 print "arg3:", arg3

args = ("two", 3)

test_var_args_call(1, *args)
```

结果: 

arg1: 1

arg2: two

arg3: 3 

\*\*kwargs 

```
def test_var_args_call(arg1, arg2, arg3):

 print "arg1:", arg1

 print "arg2:", arg2

 print "arg3:", arg3

kwargs = {"arg3": 3, "arg2": "two"}

test_var_args_call(1, **kwargs)
```

结果: 

arg1: 1

arg2: two

arg3: 3