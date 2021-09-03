# Mann-Kendall-Test

> Traditional regression test requires the residuals from the regrssion line subject to the normal distribution. However, this assumption is not required in Mann-Kendall Test, which means it is a non-parametric (distribution-free) test.

# Assumption

- When no trend is present, the measurements (observations or data) obtained over time are independent and identically distributed. The assumption of independence means that the observations are not serially correlated over time.

- The observations obtained over time are representative of the true conditions at sampling times.

- The sample collection, handling, and measurement methods provide unbiased and representative observations of the underlying populations over time.

# Process

The MK test tests whether to reject the null hypothesis ($H_0$) and accept the alternative hypothesis ($H_a$), where 

- $H_0$: No monotonic trend

- $H_a$: Monotonic trend is present

The initial assumption of the MK test is that the $H_0$ is true and that the data must be convincing beyond a reasonable doubt before $H_0$ is rejected and $H_a$ is accepted.

The MK test is conducted as follows:

1. List the data in the order in which they were collected over time,$x_1,x_2,...,x_n$, which denote the measurements obtained at times $1,2,...,n$, respectively.

2. Determine the sign of all $n(n−1)/2$ possible differences $x_j−x_k$, where $j>k$. These differences are: $x_2−x_1,x_3−x_1,...,x_n−x_1,x_3−x_2,x_4−x_2,...,x_n−x_{n−2},x_n−x_{n−1}$

3. Let $sgn(x_j−x_k)$ be an indicator function that takes on the values $1$, $0$, or $-1$ according to the sign of $x_j−x_k$, that is,
$$
sgn(x_j−x_k)=\left\{  
             \begin{array}{lr}  
             1, \text{if $x_j−x_k \gt 0$} &  \\  
             0, \text{if $x_j−x_k = 0$}, \text{or if the sign of $x_j−x_k$ cannot be determined due to non-detects} & \\  
             -1, \text{if $x_j−x_k$} \lt 0 &    
             \end{array}  
\right. 
$$
For example, if $x_j−x_k \gt 0$, that means that the observation at time $j$, denoted by $x_j$, is greater than the observation at time $k$, denoted by $x_k$.

4. Compute
$$
S=\sum_{k=1}^{n-1}\sum_{j=k+1}^n sgn(x_j−x_k)
$$
which is the number of positive differences minus the number of negative differences. If $S$ is a positive number, observations obtained later in time tend to be larger than observations made earlier. If $S$ is a negative number, then observations made later in time tend to be smaller than observations made earlier.

5. The mean of $S$ is $0$ ($E[S]=0$). The variation of $S$ is
$$
\sigma^2=\dfrac{1}{18}[n(n-1)(2n+5)-\sum_{j=1}^p t_j(t_j-1)(2t_j+5)]
$$
where $p$ is the number of the tied groups in the data set and $t_j$ is the number of data points in the j-th tied group.

6. The statistic $S$ is approximately normal distributed
provided that the following $Z$-transformation is employed:
$$
Z=\left\{
\begin{array}{lr}
\dfrac{S-1}{\sigma}, \text{if $S \gt 0$} & \\
0, \text{if $S = 0$} & \\
\dfrac{S+1}{\sigma}, \text{if $S \lt 0$} & 
\end{array}
\right.
$$
A positive (negative) value of $Z$ indicates that the data tend to increase (decrease) with time.

7. Suppose we want to test the null hypothesis $H_0$: No monotonic trend versus the alternative hypothesis $H_a$: Upward monotonic trend at the Type I error rate $\alpha$, where $0 < \alpha < 0.5$. (Note that $\alpha$ is the tolerable
probability that the MK test will falsely reject the null hypothesis.) Then $H_0$ is rejected and $H_a$ is accepted if $Z \ge Z_{1−\alpha}$, or $Z \le −Z_{1−α}$, where $Z_{1−\alpha}$ is the $100(1−\alpha)$-th percentile of the standard normal distribution. We also could combine these two criteria into one: $|Z| \ge |Z_{1−α}|$.