“Environment module”是一组环境变量设置的集合。 module可以被加载、卸载、切换，这些操作会改变相应的环境变量设置，从而让用户方便地在不同环境间切换。 相比与将环境变量设置写入/etc/profile或者~/.bashrc，Environment module操作只影响当前用户的当前登录环境，不会因错误配置造成全局持续的破坏。 普通用户也可以自己编写module，具有很好的定制性。

配置modulefiles文件 
----------------

安装完成后，可以配置modulefiles文件（动态配置模块，可能存在多个，位于MODULEPATH环境变量指定的路径中），默认在/etc/modulefiles/目录下 

```shell
#%Module -*- tcl -*-

##

## modulefile

##

proc ModulesHelp { } {

 puts stderr "\tAdds ALL SOFT to your environment variables,"

}

module-whatis "adds ALL SOFT to your environment variables"

set version 1.2.8

set root /home/share/soft

prepend-path PATH $root/bin

prepend-path LD_LIBRARY_PATH $root/lib

prepend-path INCLUDE $root/include

setenv NETCDF $root

setenv NETCDF_PATH $root

setenv NETCDF_LIB $root/lib

setenv NETCDF_INC $root/include

setenv LIB_NETCDF $root/lib

setenv INC_NETCDF $root/include

setenv JASPERLIB $root/lib

setenv JASPERINC $root/include

append-path INCLUDE $root/include
```



常用命令
----

module 查看帮助

module help 查看帮助，等价于module -h

module avail 查看可用模块

module list 查看已经加载的模块

module add \<模块名\> 加载模块，等价于module load \<模块名\>

module rm \<模块名\> 卸载模块，等价于module unload \<模块名\>

module purge 卸载所有模块

module switch \<旧模块\> \<新模块\> 替换模块，等价于module swap \<旧模块\> \<新模块\>

module whatis \<模块名\> 查看模块说明

module show \<模块名\> 查看模块内容，等价于module display \<模块名\>查看模块内容

module use -a \<路径\> 将指定路径追加到MODULEPATH中，等价于module use --append \<路径\>