> PAC是Probably Approximately Correct

假设c为某种概念，即输入样本和标记$(x,y)$，满足$c(x)=y$，我们想要学到的c的集合称为C。对于某个学习算法L，它考虑的假设空间称为H，通常$H \ne C$。如果目标概念$c \in H$，那么学习算法能够将所有样本按照与真实标记一致的方式完全分开，所以我们称该问题对学习算法L是可分的或者一致的。

用$E(h;D)=P_{x \in D}(h(x) \ne y)$表示h的泛化误差，$\hat{E}$表示的是经验误差

**PAC辨识**：对于$0<\epsilon,\delta<1$，所有$c \in C$和分布$D$，如果存在学习算法$L$，其输出假设$h \in H$满足$P(E(h) \le \epsilon) \ge 1 - \delta$，则称学习算法L能从假设空间$H$中PAC辨识概念类$C$。

**PAC可学习**：$m$表示从分布$D$中独立同分布采样得到的样本数目，$0 \le \epsilon,\delta \le 1$，对所有分布$D$，若存在学习算法$L$和多项式函数$poly$，使得对于任何$m \ge poly(1/\epsilon,1/\delta,size(x),size(c))$，$L$能从假设空间$H$中PAC可辨识概念类C，则称概念类C对假设空间H而言是PAC可学习的，如果L满足其为$poly(1/\epsilon,1/\delta,size(x),size(c))$的函数，则称C是高效PAC可学习的。如果，L能从假设空间H中输出满足：$P(E(h)-min_{h' \in H} E(h') \le \epsilon) \ge 1 - \delta$则称假设空间H是不可知PAC可学习的

#### 可分情形

假设h的泛化误差大于$\epsilon$，对分布D上随机采样而得到的样例$(x,y)$，有：
$$
P(h(x)=y)=1-P(h(x)\ne y)=1-E(h)<1-\epsilon
$$
由于有m个从分布D上采样的样本，因此h与D表现一致的概率为：
$$
P(h(x_1)=y_1)...P(h(x_m)=y_m)=(1-P(h(x) \ne y))^m < (1-\epsilon)^m
$$
我们事先并不知道学习算法会输出H中的哪个假设，但只要保证泛化误差大于$\epsilon$，且在训练集上表现完美的所有假设出现概率之和不大于$\delta$即可：
$$
P(h\in H:E(h)\gt \epsilon \cap \hat{E}(h)=0) \lt |H|(1-\epsilon)^m \lt |H|e^{-m\epsilon}
$$
令上式小于$\delta$，即可解得
$$
m \ge \frac{1}{\epsilon} (ln |H| + ln \frac{1}{\delta})
$$

#### 不可分情形

对于较为困难的学习问题，往往目标概念c不存在于假设空间H中，H中任何一个假设都会或多或少在训练集上出现错误。

对于任意$h \in H, 0 \lt \epsilon \lt 1$，满足：
$$
P(\hat{E}(h)-E(h) \ge \epsilon) \le exp(-2m\epsilon^2) \\
P(E(h)-\hat{E}(h) \ge \epsilon) \le exp(-2m\epsilon^2) \\
P(|\hat{E}(h)-E(h)| \ge \epsilon) \le exp(-2m\epsilon^2)
$$
从而可以推导出：
$$
\hat{E}(h)-\sqrt{\dfrac{ln(2/\delta)}{2m}} \le E(h) \le \hat{E}(h) + \sqrt{\dfrac{ln(2/\delta)}{2m}}
$$
样本数目m较大时，h的经验误差是其泛化误差的很好的近似

这一点说明了一个问题，当用CNN等复杂的模型时，如果样本过少，则很容易造成过拟合

