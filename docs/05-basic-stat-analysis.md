---
output: html_document
editor_options: 
  chunk_output_type: console
---



\footnotesize



 \normalsize

# R을 활용한 기초통계 분석{#basic-stat-analysis}


> **Sketch**
>
> - Q-Q plot $\rightarrow$ 데이터가 특정 분포를 따르는가? 
> - paired t test, independent two sample t test $\rightarrow$ 연속형 반응변수 vs. 범주가 2개인 범주형 변수
> - Oneway ANOVA test $\rightarrow$ 연속형 반응변수 vs. 범주가 2개 이상인 범주형 변수
> - $\chi^2$ & Fisher's exact test $\rightarrow$ 두 범주형 변수 간 연관성(독립성) 검정
> - Correlation between two continuous variables $\rightarrow$ Pearson's correlation coefficient


\footnotesize

<img src="figures/sats-flowchart.jpg" width="100%" style="display: block; margin: auto;" />

 \normalsize


## Q-Q plot {#qqplot}

> Q-Q plot = Quantile(분위수)-Quantile(분위수) plot


### 분위수(Quantile) {#quantile-def}


#### 정의 {#quantile-definition .unnumbered}

- 확률분포를 동등한 확률 구간으로 나누기 위해 설정한 구분점(cutpoint)
- 특정 확률분포의 누적분포함수의 역함수
- 주어진 표본의 관찰값을 오름차순으로 나열했을 때 전체 표본(데이터)을 특정 개수의 그룹으로 나눌 때 기준이 되는 값
- $q$ 분위수는 $q-1$ 개의 분위수 값을 갖음
- 예시
   - 2-quantile: 오름차순으로 정렬한 데이터를 50:50으로 나누기 위한 값 $\rightarrow$ 중앙값(median)
   - 3-quantiles (tertiles):  오름차순으로 정렬한 데이터를 3 등분 하기 위한 값 $\rightarrow$ 33.3 %, 66.6 %
   - 4-quantiles (quartiles): 오름차순 정렬 데이터를 4등분 하기 위한 값 $\rightarrow$ 25 % (Q1), 50 % (중앙값), 75 % (Q3)
      - 사분위수 범위(interquartile range, IQR): Q3 - Q1
   - 10-quantiles (deciles): 오름차순 정렬 데이터를 10 등분 $\rightarrow$ 10 %, 20 %, 30 %, ..., 90 %
   - 100-quantiles (percentiles): 오름차순 정렬 데이터를 10 등분 $\rightarrow$ 1 %, 2 %, ..., 99 %
- 일반적으로 $k^{\mathrm{th}}$ $q$ 분위수는 누적확률분포에서 $k/q$의 값을 갖는 데이터를 의미


#### (표본)분위수의 계산 {.unnumbered}


\footnotesize

\BeginKnitrBlock{rmdnote}<div class="rmdnote">R에서 표본 분위수는 `quantile()` 함수룰 통해 구할 수 있으먀, 크게 불연속 변수(discontinuous variable)와 
연속 변수(continuous variable)에 따라 방법이 조금씩 달라짐. 불연속변수인 경우 데이터 중에서
분위수 값을 정의하는 반면 연속변수인 경우 보간(interpolation)을 사용해 분위수 값을 정함. R은 총 9 가지의 분위수 계산 방법을 제공하며, 방법 1 ~ 3은 불연속 변수, 
방법 4 ~ 9 는 연속 변수를 대상으로 함. 
</div>\EndKnitrBlock{rmdnote}

 \normalsize


표본 분위수는 순서통계량(order statistics)^[순서통계량은 확률변수 $X$를 $n$ 개 관찰을 했을 때 $X$를 크기 순으로 배열한 통계량으로 $X_{(1)} < X_{(2)} < \cdots <X_{(n)}$ 로 나타냄(순서통계량은 서로 독립이 아님)]의 가중평균으로 정의하며 임의의 표본이 주어졌을 때 $p \times 100$ %  분위수 계산 식^[R `quantile(x, probs, type = 5)`와 동일]은 아래와 같음(연속 변수에 대해)


$$
Q(p) = (1 - \gamma) x_{(k)} + \gamma x_{(k+1)}
$$


이고, 여기서 $(k - 0.5)/n \leq p < (k - 0.5 +1)/n$, $x_{(k)}$는 $k$ 번째 순서통계량, $n$은 표본크기, $\gamma = np + 0.5 - k$, $k$는 $np + m$을 넘지 않는 최대 정수임. 


- 예시 


\footnotesize


```r
# 분위수 계산 함수 
my_quantile <- function(x, probs) {
  idx <- NULL
  o <- order(x); n <- length(x)
  xord <- x[o]
  k <- 1:n
  gamma <- n * probs + 0.5 - floor(n * probs + 0.5)
  pk <- (k - 0.5)/n
  for (pj in probs) {
    idx <- c(idx, which.max(pk[pk <= pj]))
  }
  res <- (1 - gamma) * xord[idx] + gamma * xord[idx + 1]
  names(res) <- sprintf("%.1f %%", round(probs * 100))
  return(res)
}


set.seed(10)
x <- rnorm(373)
my_quantile(x, probs = c(0.05, 0.95))
```

```
    5.0 %    95.0 % 
-1.601323  1.492466 
```

```r
# 확인
quantile(x, probs = c(0.05, 0.95), type = 5)
```

```
       5%       95% 
-1.601323  1.492466 
```

 \normalsize


#### Quantile-Quantile plot (Q-Q plot) {.unnumbered}


- 두 변수 $X$의 분위수와 $Y$의 분위수를 산점도 형태로 그린 도표로 두 변수의 분포를 비교하기 위한 용도로 사용되는 도표
- 예시
   - $X$: 충남대학교 정보통계학과 남학생의 키
   - $Y$: 충남대학교 자연과학대학 남학생의 몸무게

\footnotesize


```r
# 개념
set.seed(1234)
x <- rnorm(50, 172, 15)
y <- rnorm(500, 65, 20)

xq <- quantile(x, probs = seq(0, 1, by = 0.05))
yq <- quantile(y, probs = seq(0, 1, by = 0.05))
plot(xq, yq, 
     xlab = "height", 
     ylab = "weight")
```

<img src="05-basic-stat-analysis_files/figure-html/unnamed-chunk-6-1.svg" width="672" />

 \normalsize


- 일반적으로 측정 또는 표집한 연속형 변수가 이론적인 특정 분포와 얼마나 유사한지를 확인하기 위해 사용하며, 특히 데이터의 정규성 검정에 많이 활용됨. 
즉 표본으로 얻은 분포가 정규분포를 따르는지(유사한지)를 알아보기 위해 활용

- 보통 x 축은 theoretical quantile (이론적 분위수)로 하고 비교하고자 하는 이론적 분포의 분위수 값을 설정하고 y 축은 표본 분위수(empirical/sample quantile)로 설정 

- R에서 Q-Q plot은 `qqnorm()`, `qqplot()` 등의 함수를 사용해 간단히 그릴 수 있으나 해당 함수를 사용하지 않고 직접 그리는 방법에 대해 알아봄. 


\footnotesize


```r
# 위 예제에서 생성한 충남대학교 여학생 몸무게의 Q-Q plot
# 정규분포와 비교
yord <- y[order(y)] # 데이터 정렬
n <- length(yord)
k <- 1:n
pk <- (k - 0.5)/n
# theoretical quantile
tq <- qnorm(pk, 0, 1) # 표준정규분포의 분위수
# empirical quantile
eq <- drop(scale(yord)) # z 변환

par(mfrow = c(1, 2))
plot(x = tq, y = eq, 
     type = "n", 
     xlim = c(-3.5, 3.5), 
     ylim = c(-3.5, 3.5), 
     xlab = "Theoretical Quantile", 
     ylab = "Empirical Quantile", 
     main = "Normal Q-Q plot (manual)")
points(tq, eq, pch=16, cex = 1, col = "darkgray")
points(tq, eq, pch=21, cex = 1, col = "black", lwd = 1)
abline(a = 0, b = 1)

# qqnorm() 함수 결과와 비교
qqnorm(eq, xlim = c(-3.5, 3.5), ylim = c(-3.5, 3.5))
qqline(eq)
```

<img src="05-basic-stat-analysis_files/figure-html/unnamed-chunk-7-1.svg" width="768" />

 \normalsize


#### Q-Q plot의 형태 {.unnumbered}


## 연속형 변수의 두 집단의 비교 {#two-group-comp}


### 독립 이표본 t 검정(independent two-sample t-test)


### 대응 표본 t 검정(paired samples t test)


## 일원배치 분산분석(oneway analysis of variance, ANOVA)


## 범주형 자료분석(categorical data analysis)


### 적합성 검정(goodness-of-fit test)


### 독립성 검정


### Fisher 정확검정


## 두 변수의 상관



