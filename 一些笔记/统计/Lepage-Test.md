# Lepage-Test


Lepage test is a distribution free two-sample test.

In the two-sample problem considered here the observations within each sample are assumed to be independent and identically distributed. In addition, independence between the samples is assumed.

Let $X_1,...,X_n$ and $Y_1,...,Y_N$ denote the two random samples, with $F$ and $G$ being the corresponding distribution functions. In the nonparametric location–scale model, the distribution functions are related as follows:

$$
G(t) = F(\theta_1 t - \theta_2)
$$

with $\theta_1 \gt 0$ and $-\infty \lt \theta_2 \lt \infty$.

The null hypothesis $H_0$ is $\theta_1=1$ and $\theta_2=0$, hence, there is no diﬀerence between $F$ and $G$. If the two standard deviations $\sigma_F$ and $\sigma_G$ existed, we have $\sigma_G/\sigma_F=1$. The alternative $H_1$ states $\theta_1 \ne 1$ or $\theta_2 \ne 0$. Thus, changes in location or in scale should be detected by a location–scale test.

Several nonparametric location–scale tests were reviewed by Goria (1982). Many of them, including more recent tests, combine a test for diﬀerences in location with a test for diﬀerences in dispersion by using the sum of the two test statistics. The test statistic of Lepage’s test is the sum of Wilcoxon's and Ansari–Bradley's statistics.

Let $V_i=1$ when the $i$-st smallest of the $N=n+m$ observations is from the ﬁrst sample and $V_i=0$ otherwise. The Wilcoxon rank-sum statistic is deﬁned by

$$
T_W = \sum_{i=1}^N i \cdot V_i
$$

The Ansari–Bradley test is a rank test for dispersion, the test statistic is deﬁned by

$$
T_{AB}=\dfrac{1}{2}n(N+1)-\sum_{i=1}^N|i-\dfrac{1}{2}(N+1)|\cdot V_i
$$

The test statistic of Lepage’s test is

$$
L=(\dfrac{T_W-\mu_W}{\sigma_W})^2+(\dfrac{T_{AB}-\mu_{AB}}{\sigma_{AB}})^2
$$

where $\mu_i$ and $\sigma_i^2$ ($i\in\{W,AB\}$) are the expected values and variances, respectively. The statistic $L$ is, under $H_0$, asymptotically $\chi^2$ distributed with two degrees of freedom.

In another paper, the formula of Lepage test is more applicable.

$$
HK=\dfrac{(W-E(W))^2}{V(W)}+\dfrac{(A-E(A))^2}{V(A)}
$$

Let $x=(x_1,...,x_{n_1}), y=(y_1,...,y_{n-1})$ be two independent samples of size $n_1$ and $n_2$, respectively. It is assumed that $u_i=1$ if the $i$th smallest observation is in a combined sample of size $2n=n_1+n_2$ belongs to $x$, and let $u_i=0$ if it belongs to $y$. Each term of the above equation could be expressed as follows:

$$
W = \sum_{i=1}^{2n}iu_i \\
E(W)=\dfrac{1}{2}n_1(n_1+n_2+1) \\
V(W)=\dfrac{1}{12}n_1n_2(n_1+n_2+1) \\
A=\sum_{i=1}^n iu_i+\sum_{i=n+1}^{2n}(2n-i+1)u_i \\
E(A)=\dfrac{1}{4}n_1(n_1+n_2+2) \\
V(A)=\dfrac{n_1n_2(n_1+n_2-2)(n_1+n_2+2)}{48(n_1+n_2-1)}
$$
