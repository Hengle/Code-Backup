为了能够充分利用VPS，我现在把我的Github Pages主页迁移到VPS。这个问题其实就是一个如何利用git提交一次到github然后再提交一次到VPS。 

### VPS端 

需要提前安装好nginx和git。这里我用的是[LNMP一键安装包](https://lnmp.org/)。 

然后在VPS上： 

```shell
mkdir jekyll

cd jekyll

git init jekyll --bare

mv jekyll .git
```

建立一个git裸仓库，用于接收本地网页的git push，以及布署git hook进行文件操作。

```shell
cd .git/hooks

touch post-receive

chmod +x post-receive
```

把下面这段输入到post-receive中

```shell
#!/bin/sh

# 把仓库新收到的文件复制到临时文件夹

git clone /root/jekyll /tmp/jekyll

# 删除旧的网页文件

rm -rf /home/wwwroot/default/*

# 复制新的网页文件到网页文件夹

cp -r /tmp/jekyll/* /home/wwwroot/default/

# 删除临时文件

rm -rf /tmp/jekyll
```

这里的jekyll是我们之前建立的裸仓库，而目录`/home/wwwroot/default/`是LNMP一键安装脚本安装后的默认静态网页放置的位置。 

### 本地端 

在原先的Github Pages目录下新建一个文件用于两次提交： 

```shell
#!/bin/sh

# 清理后再生成Jekyll网页

bundle exec jekyll clean

bundle exec jekyll build

# 在网页目录建立git

cd _site

git init

# 添加VPS上的裸仓库作为远程仓库

git remote add jekyll root@167.99.93.69:/root/jekyll

# 提交并推送，这里的commit信息我定的是提交时间

git add .

commit_time=$(date "+%Y-%m-%d %H:%M:%S")

git commit -m "${commit_time}"

git push -f jekyll master:master

# 删除本地网页文件夹

cd ../

rm -rf _site

# 将Jekyll工程文件提交到GitHub

git add .

git commit -m "up"

git push 
```

然后只要写完，运行下这个脚本就能提交啦~