文件资源 
-----

* [搜狗输入法皮肤](resources/383C81EBD4D44129EB6A05E02BB9DB21.zip)

* [字体](resources/BFC85D110D996F187F21511BB382D058.zip)

* [壁纸](resources/E1466CD63CBD01402198926A815591DE.zip)

* [Übersicht插件](resources/EBCC0C5E809F6CC71A529B371A35C169.zip)

* [终端配置文件（需要配置字体）](resources/679B0612544B82E319FB5CFE772DF56F.terminal)

Alfred配置文件 
-----------

* [Douban.alfredworkflow](resources/C64E6325371DE68270E941299916E588.alfredworkflow)

* [bilibili.alfredworkflow](resources/9204F677DEBD0D7B4BE09AFE2DEA5345.alfredworkflow)

Chrome插件 
---------

* Grammarly for Chrome
* Math Anywhere
* Sci-hub
* Bookmark Manager

Mac App 
--------

* Alfred
* Google Chrome
* FileZilla
* Netease Music
* QQ音乐
* WeChat
* Microsoft Office: Word, PPT, Excel
* CleanMyMac
* VLC
* Xcode
* Papers
* Magnet
* Leetcode-cli: <https://github.com/skygragon/leetcode-cli>
* Shadowsocks-NG
* Bartender
* Dr. Unarchiver
* Paragon
* Duet
* PDF Expert
* Sublime Text
* Texpad
* Day One
* Notability
* Typora
* QQ
* TickTick 
* Panoply

bash\_profile
=============

```shell
# Following are my environment settings
ulimit  -m unlimited
ulimit  -d unlimited
ulimit  -v unlimited
ulimit  -t unlimited
ulimit  -l unlimited
set +o noclobber                     

PS1="[\u@\h \W]\$ "

alias icloud='cd /Users/QQF/Library/Mobile\ Documents/27N4MQEA55~pro~writer/Documents'

export LS_OPTIONS='--color=auto' 
export CLICOLOR='Yes'
export LSCOLORS='ExgxcxdxcxegedabagGxGx' 
```

数值计算环境变量配置
==========

```shell
# My soft for numerical model

export AllSoft=/Users/qqf/Software

export PATH=${AllSoft}/anaconda3/bin:${PATH}

export ZLIB=${AllSoft}/zlib
export LD_LIBRARY_PATH=${ZLIB}/lib:${LD_LIBRARY_PATH}
export INCLUDE=${ZLIB}/include:${INCLUDE}

export SZIP=${AllSoft}/szip
export LD_LIBRARY_PATH=${SZIP}/lib:${LD_LIBRARY_PATH}
export INCLUDE=${SZIP}/include:${INCLUDE}

export JASPER=${AllSoft}/jasper
export LD_LIBRARY_PATH=${JASPER}/lib:${LD_LIBRARY_PATH}
export INCLUDE=${JASPER}/include:${INCLUDE}
export JASPERLIB=${JASPER}/lib
export JASPERINC=${JASPER}/include

export NETCDF=${AllSoft}/netcdf
export LD_LIBRARY_PATH=${NETCDF}/lib:${LD_LIBRARY_PATH}
export INCLUDE=${NETCDF}/include:${INCLUDE}
export NETCDF_INC=${NETCDF}/include
export NETCDF_LIB=${NETCDF}/lib
export INC_NETCDF=${NETCDF}/include
export LIB_NETCDF=${NETCDF}/lib

export HDF5=${AllSoft}/hdf5
export LD_LIBRARY_PATH=${HDF5}/lib:${LD_LIBRARY_PATH}
export INCLUDE=${HDF5}/include:${INCLUDE}

export UDUNITS=${AllSoft}/udunits
export LD_LIBRARY_PATH=${UDUNITS}/lib:${LD_LIBRARY_PATH}
export INCLUDE=${UDUNITS}/include:${INCLUDE}
export PATH=${UDUNITS}/bin:${PATH}

export OPENMPI=${AllSoft}/openmpi
export LD_LIBRARY_PATH=$${OPENMPI}/lib:${LD_LIBRARY_PATH}
export INCLUDE=${OPENMPI}/include:${INCLUDE}
export PATH=${OPENMPI}/bin:${PATH}
export INC_MPI=${OPENMPI}/include
export LIB_MPI=${OPENMPI}/lib

export CC=gcc
export FC=gfortran
export SCC=gcc
export CXX=g++
export F77=gfortran
export F90=gfortran
export MPICC=mpicc
export MPICXX=mpicxx
export MPIF90=mpif90
export MPIF77=mpif77
#export CPP='icc -E'
#export CXXCPP='icpc -E'
#export CFLAGS='-O3 -xHost -ip -fPIC'
#export CXXFLAGS='-O3 -xHost -ip -fPIC'
#export FCFLAGS='-O3 -xHost -ip -fPIC'

export NCARG_ROOT=${AllSoft}/ncl
export NCARG_LIB=${NCARG_ROOT}/lib
export NCARG_INC=${NCARG_ROOT}/include
export PATH=${NCARG_ROOT}/bin:${PATH}
export LD_LIBRARY_PATH=${NCARG_ROOT}/lib:${LD_LIBRARY_PATH}
export INCLUDE=${NCARG_INC}/include:${INCLUDE}
export GEODIAG_ROOT=${AllSoft}/geodiag
export GEODIAG_PACKAGES=${GEODIAG_ROOT}/packages
export GEODIAG_TOOLS=${GEODIAG_ROOT}/tools
export PATH=${PATH}:${GEODIAG_ROOT}

export WRFIO_NCD_LARGE_FILE_SUPPORT=1
```

