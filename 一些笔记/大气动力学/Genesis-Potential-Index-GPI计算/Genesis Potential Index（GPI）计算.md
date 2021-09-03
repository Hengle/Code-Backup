# Genesis Potential Index（GPI）计算

GPI的公式大同小异，所以这里先以Murakami and Wang (2010)的GPI为例：
$$
GPI=|10^5 \eta|^{3/2}\times (\dfrac{RH}{50})^3 \times(\dfrac{V_{opt}}{70})^3 \times(1+0.1V_{shear})^{-2}\times (\dfrac{-\omega+0.1}{0.1})^3
$$
这当中需要计算的几个核心变量是：

| 变量名      | 含义                                              |
| ----------- | ------------------------------------------------- |
| $\eta$      | 850hPa绝对涡度（$s^{-1}$）                        |
| RH          | 700hPa相对湿度（%）                               |
| $V_{opt}$   | Emanuel定义的潜在强度（potential intensity；m/s） |
| $V_{shear}$ | 850hPa和200hPa风切变（m/s）                       |
| $\omega$    | 500hPa垂直速度（Pa/s）                            |

$\eta$的计算公式如下：
$$
\eta=2 \Omega sin(\psi)+VOR=2*(2*\pi/86400)*sin(lat*\pi/180)+VOR \\
VOR=relative\ vorticity
$$
RH可以直接从再分析资料中读取

$V_{shear}$的计算方法如下：
$$
V_{shear}=\sqrt{(U200-U850)^2+(V200-V850)^2}
$$
$\omega$可以直接从再分析资料中读取

$V_{opt}$是所有变量中计算最复杂的一个，计算公式为：
$$
V_{opt}=\sqrt{\dfrac{C_k}{C_d} \dfrac{SST-T_o}{T_o} (k_0^*-k)}
$$
这当中的变量名可以不用管，直接看计算过程

网上获得的Fortran代码里，核心的是PCMIN

PCMIN用于计算热带气旋能达到的最大风速（maximum wind speed）和最低中心气压（minimum central pressure）

需要从再分析资料中获得或者诊断后输入PCMIN的变量有：

| 变量名 | 含义                                       |
| ------ | ------------------------------------------ |
| SST    | 海温，℃                                    |
| PSL    | 海平面气压，mb/hPa                         |
| P      | 单个大气柱的气压，mb/hPa                   |
| T      | 单个大气柱的温度，℃                        |
| R      | 单个大气柱的水汽混合比，mixing ratio，g/kg |

注意，P、T、R这三个变量，需要从低到高（大气从底到顶）排列，换言之，P[0]代表的是大气底，P数组应该是递减。

PCMIN输出的变量有：

| 变量名 | 含义                                          |
| ------ | --------------------------------------------- |
| PMIN   | 中心最低气压，mb/hPa                          |
| VMAX   | 最大风速，m/s                                 |
| IFL    | 1代表计算成功；0代表无辐合；2代表CAPE计算失败 |

PCMIN会调用CAPE这个subroutine用于计算CAPE，但是细节可以不用纠结。

PCMIN还需要输入NA和N两个量，对于再分析资料而言，NA和N只要给垂直层数即可（P、T、R的垂直维度）。

在调用PCMIN后，检查IFL是否为1。如果IFL为1，则$V_{opt}=VMAX$，否则直接设置为空值。

从[Emanuel的网页](http://emanuel.mit.edu/)上下载到的文件有：

| 文件名                                 | 含义                             |
| -------------------------------------- | -------------------------------- |
| pcmin_2013.f                           | 计算PCMIN的原始FORTRAN文件       |
| pcmin_2013_wrapit.f和func_cal_vpot.ncl | 修改后ncl可以调用的PCMIN计算程序 |
| pi.py                                  | 用python编写的计算PCMIN的程序    |

**备注：**这里需要注意，我们往往需要计算的是GPI的气候态，因此有两种时间分辨率的计算数据选择。一种是使用日数据计算GPI，然后换算成月、年的数据；另一种是直接使用月数据计算。第一种计算方法的参考文献有：Subtropical high affects interdecadal variability of tropical cyclone genesis in the South China Sea；第二种计算方法的参考文献有：Degree of simulated suppression of Atlantic tropical cyclones modulated by flavour of El Niño和Use of a Genesis Potential Index to Diagnose ENSO Effects on Tropical Cyclone Genesis。两种方法都有人计算。

参考文献

Li, H., Xu, F., Sun, J., Lin, Y., & Wright, J. S. (2019). Subtropical High affects interdecadal variability of tropical cyclone genesis in the South China Sea. *Journal of Geophysical Research: Atmospheres*, *124*(12), 6379-6392.

Patricola, C. M., Chang, P., & Saravanan, R. (2016). Degree of simulated suppression of Atlantic tropical cyclones modulated by flavour of El Niño. *Nature Geoscience*, *9*(2), 155-160.

Murakami, H., & Wang, B. (2010). Future change of North Atlantic tropical cyclone tracks: Projection by a 20-km-mesh global atmospheric model. *Journal of Climate*, *23*(10), 2699-2721.

Camargo, S. J., Emanuel, K. A., & Sobel, A. H. (2007). Use of a genesis potential index to diagnose ENSO effects on tropical cyclone genesis. Journal of Climate, 20(19), 4819-4834.
