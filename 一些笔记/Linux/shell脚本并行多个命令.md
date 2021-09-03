从网上看到有两种做法 

第一种 

```shell
for ip in 192.168.0.{1..255}

do

 (

 ping $ip -c2 &> /dev/null

 if [ $? -eq 0 ];

 then

 echo "$ip 在线"

 fi

 )&

done

wait
```

第二种 

使用parallel。 

先将命令整理成一个文件 

file.sh内容 

bash 1.sh 

bash 2.sh 

bash 3.sh 

... 

只要cat file.sh | parallel -j 20 

就可以20个线程同时执行