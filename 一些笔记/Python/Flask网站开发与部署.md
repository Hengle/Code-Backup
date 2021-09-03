> 在使用现在这个博客之前，笔者曾自己折腾过一个博客，当时用到的框架是Flask，数据库是MongoDB。最后部署在Nginx服务器上。不过这个博客现在已经不使用了，因为长期部署在VPS上对个人来说实在太昂贵。Flask是一个非常灵活易用的框架，笔者在折腾这个博客01版的时候主要是参考了《Flask Web开发》这本书以及网上的很多资料。

虚拟环境搭建 
-------

VirtualEnv用于在一台机器上创建多个独立的Python运行环境，VirtualEnvWrapper为前者提供了一些便利的命令行上的封装。 

Virtualenv是一个非常好的virtual python environment builder，它最大的好处是，可以让每一个python项目单独使用一个环境，而不会影响python系统环境，也不会影响其他项目的环境。 

Virtualenv可用于创建独立的Python环境，在这些环境里面可以选择不同的Python版本或者不同的Packages，并且可以在没有root权限的情况下在环境里安装新套件，互相不会产生任何的影响。同时，当遇到项目需要迁移时，在服务器上都不用安装virtualenv，直接将virtualenv创建的目录拷贝到服务器，修改路径，进行虚拟环境迁移就可以用了。 

### 安装 

VirtualEnv的安装非常简单，安装方法如下: 

pip install virtualenv 这是Python2的方法

pip3 install virtualenv 这是Python3的方法

PS：国内有时候连接国外的网站不太稳定而且速度不快，豆瓣给大家弄了一个源，既快又稳定，pip安装东西只需要： 

pip install -i <http://pypi.douban.com/simple/> yoursoftname

### 使用 

VirtualEnv的使用也非常容易，只需一行命令： 

virtualenv --no-site-packages --python=2.7 envname

--no site-pachages：表示不包括系统全局的Python安装包，这样会更令环境更干净 

–python=python2.7：指定Python的版本，系统已经安装了的Python2.7 

envname：建立的虚拟环境名称，会自动创建同名的虚拟环境目录 

进入虚拟环境现在只需要运行：source envname/bin/activate即可 

进入虚拟环境后，命令行的提示符会加入虚拟环境的名称，例如：(venv)QQF@localhost:~$ 

退出虚拟环境只需要：deactivate 

如果不想要这个虚拟环境了，只需要删除虚拟环境所在的文件夹就删除了我们创建的虚拟环境。因为虚拟环境只在当下这个项目里起作用，所以不会造成任何其他影响。 

### 迁移 

为了项目迁移的方便，可以制作一个列表，列出本项目所需的所有安装包：pip freeze \> requirements.txt 

之后到了新机器上，我们只需要：pip install -r requirements.txt，pip就会自动帮我们下载好所有列表中的安装包并安装到虚拟环境中。 

Flask搭建网站的一些思路 
---------------

> 在搭建网站之前，首先要明确一点，是想做静态网站还是动态网站。静态网站特点是，网页内容一经发布到网站服务器上，无论是否有用户访问，每个静态网页的内容都是保存在网站服务器上的。因此，网站的每个页面都是实实在在的一个个文件。如果网站的规模较大，这就会给维护工作带来很大的难度。动态网站主要以数据库技术为基础，可以大大降低网站维护的工作量，但与此同时，需要对数据库进行维护和调整。动态网站最大的好处是，可以对网站内容很方便地进行扩展，交互性较强。对于博客这样的小型网站，做成静态应该更加合理，这也是笔者后面放弃了博客01的一个原因。

### 大体思路 

网站的构建其实可以分成几个不同的部分： 

Flask是网站的骨架，主要负责和用户发给服务器的请求对接，实现网页的跳转等等功能；模板引擎如Jinja，Mako等等是网页页面的骨架，它们可以生成一个个html文件，然后通过Flask展现给用户；CSS（Cascading Style Sheets）则是网页页面的效果，例如字体大小啦，颜色啦等等；Javascript则提供了页面的很多操作，例如动画啦，点击提交表单啦等等。这样，我们可以把整个网站解构为不同的部分，每次只需要专注完成一个部分，最终就可以把整个网站全部写出来。数据库则负责存储各种网站所需要的数据，例如用户信息等等。 

### Flask的简单使用 

Flask的官方网站(<http://flask.pocoo.org/>)给出了很好的例子，这里就不赘述了。Flask的使用要点是： 

1. 创建Flask对象实例是程序的入口，是整个网站开始的地方，只有建立了创建Flask对象实例（一般命名为app），才能够继续下面的工作
2. Flask通过装饰器来完成路由。我们在程序中总可以看到：@app.route('/')这种装饰器，单引号里面的内容就是装饰器装饰的函数所对应的网页的功能。程序实例需要知道对每个URL请求运行哪些代码，所以保存了一个URL到Python函数的映射关系。
3. 装饰器路由所装饰的函数就是网页。例如我定义网站主页def index()并把这个函数放在@app.route('/')后面，所以就是把index()函数注册为路由。当我访问网站所在服务器的域名，它就会触发执行这个函数，同时我就可以看到网站主页。主页的内容主要通过index()这个函数里的return语句提供。这种能够提供网页的函数被称为视图函数。各种各样的视图函数连接了Flask和网页的其他部分。
4. Flask与数据库的交互。这是很重要的一点。在博客01中，所有的文章，以及用户信息都存放在MongoDB中。值得庆幸的是Python提供了操作数据库所需要的各种函数，非常方便。
5. 合并蓝图。《Flask Web开发》中提到了合并蓝图的作用，但是博客01中我并没有去合并蓝图，因为博客01实在是很简单很轻量的一个程序。但是对于大型的程序，合并蓝图可以简化代码，为维护提供了很大的便利。

### 模板引擎 

模板引擎就是通过Flask的视图函数传进来的参数等等生成一个个HTML文件然后返回给Flask，最终呈现给用户。模板引擎的使用要点和HTML一样，主要是构造出一个个网页页面的大体框架，把网页划分为一个个块，这样方便后续利用CSS和Javascript对每个块进行装饰和操作。使用模板引擎的一种思路是，先写好一个基础模板，即每个网页都会用到的一些东西，然后利用模板继承可以大幅度简化模板的处理。 

### CSS 

CSS的使用有非常多的技巧。首先我们要理解CSS的盒子模型，然后结合模板引擎里写好的网页骨架逐渐增加装饰。使用CSS可以参考这个网站([W3School](http://www.w3school.com.cn/index.html))。里面有很详细的HTML，CSS和Javascript的教程和参考手册。 

### Javascript 

Javascript可以用来改进设计、验证表单、检测浏览器、创建cookies等等各种功能，让网站变得丰富多彩。详细内容除了可以在[W3School](http://www.w3school.com.cn/index.html)上看，同时也可以参考[慕课网](http://www.imooc.com/)的相关课程。 

### 数据库 

一般免费好用的数据库有三个典型代表：MySQL，MongoDB和Redis。Redis是纯内存型的数据库，但是对服务器的内存要求很高，如果内存不够多的话，还是换个其他的数据库吧。MySQL是最常用的一种，因为它的性能确实很一般，只是对硬件要求不高，基本上硬盘够大就行了。MySQL是一种典型的关系型数据库，需要进行建表，所以使用起来有时候并不是特别方便。介于Redis和MySQL之间的就是MongoDB。MongoDB是一种典型的NoSQL，免去了蛋疼的建表操作。具体选择哪种数据库，需要根据网站的受众和服务器硬件条件。 

部署 
---

1. 在服务器上安装Nginx，MongoDB和Uwsgi
2. 关闭selinux，打开/etc/selinux/config, 把其中的SELINUX=enforcing改成SELINUX=disabled
3. 启动MongoDB，可以采用以下命令：

mongod --dbpath=/root/RaphaelBlog/data/db --logpath=/root/RaphaelBlog/data/mongo.log --fork

--dbpath表示数据库的存储路径 

--logpath表示数据库的记录文件存储路径 

--fork表示利用后台Daemon方式启动，设置了这个参数就一定要设置logpath参数 

1. 启动Uwsgi，可以使用命令：

uwsgi --ini /blog/uwsgi.ini -d /blog/log

--ini表示启动时的配置文件 

-d表示记录文件的位置 

1. 修改Nginx的配置文件nginx.conf，然后service nginx start
2. 这样就完成部署了。域名的绑定可以去[万网](https://www.aliyun.com)购买一个域名，告诉他们IP就可以实现绑定。