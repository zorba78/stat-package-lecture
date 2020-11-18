## Homework 3

1. 설명변수 $x_i$와 $y_i$, $i = 1, 2, \ldots, n$ 가 주여졌을 때 다음과 같은 반응변수 $Y_i$에 대한 설명변수 $x_i$의 단순선형회귀모형(simple linear regression)을 
고려해보자. 


$$
y_{i} = 5 + -2.5 x_i + \epsilon_i, ~~ \epsilon_i \sim \mathcal{N}(0, 9), ~~ x_i \sim \mathcal{U}(0, 10)
$$

a) 위 모형 $_{i} = 5 + -2.5 x_i + \epsilon_i, ~~ \epsilon_i$를 행렬과 벡터 형태로 나타내기 위한 행렬 및 벡터를 정의하고, 정의한 행렬/벡터로 위 모형을 표시하시오. 


<!-- > - $\mathbf{y}_{n \times 1} = [y_1, \ldots, y_n]^T$ -->
<!-- > - $\mathbf{X}_{n \times 2} = [\mathbf{1}, \mathbf{x}]$, $\mathbf{x} = [x_1, \ldots, x_n]^T$ -->
<!-- > - $\boldsymbol{\mathbf{\beta}}_{2 \times 1} = [5, -2.5]^T$ -->
<!-- > - $\boldsymbol{\mathbf{\epsilon}}_{n \times 1} = [\epsilon_1, \ldots, \epsilon_n]^T$ -->



<!-- $$ -->
<!--  \mathbf{y} = \mathbf{X}\boldsymbol{\mathbf{\beta}} + \boldsymbol{\mathbf{\epsilon}} -->
<!-- $$ -->


b) $y_i$가 정규분포를 따른다고 가정할 때, 설명변수 $x_i$가 주어졌을 때 반응변수 $y_i$는 어떤 분포를 따르는지 행렬과 벡터로 표시하시오. 



<!-- $$ -->
<!--  \mathbf{y} \sim \mathcal{N} \left (\mathbf{X}\boldsymbol{\mathbf{\beta}}, 9\mathbf{I}_{n \times n} \right ) -->
<!-- $$ -->



c) 주어진 모형으로부터 $y_i$를 생성하고($i=1,\ldots, 30$), 생성한 $x_i$와 $y_i$의 산점도를 그리시오. 단, seed 번호는 `20201111`로 고정하시오. 



<!-- ```{r} -->
<!-- set.seed(20201111) -->
<!-- n_sample <- 30 -->
<!-- btrue <- c(5.0, -2.5) -->
<!-- x <- runif(n_sample, 0, 10) -->
<!-- e <- rnorm(n_sample, 0, 9) -->
<!-- y <- drop(cbind(1, x) %*% btrue) + e -->
<!-- plot(x, y) -->


<!-- ``` -->




2. 수업시간에 학습한 미분 가능한 특정 방정식의 해를 구하는 Newton-Raphson (N-R) 방법을 응용해 문제 1에서 생성한 `y`와 `x`로부터 회귀식(`x`의 기울기와 절편) 추정이 가능하다. 
단순회귀모형 및 다중회귀모형에서 회귀계수 추정의 기본 아이디어는 오차 제곱의 힙 $\sum\epsilon_i = \boldsymbol{\mathbf{\epsilon}}^T\boldsymbol{\mathbf{\epsilon}}$ 를 
최소화하는 $\beta_0$와 $\beta_1$ 또는 $\boldsymbol{\mathbf{\beta}}_{p\times 1}$을 찾는 것이고, 이 문제를 아래와 같이 나타낼 수 있다. 

$$
 \arg \min \left\{ (\mathbf{y}_{n \times 1} - \mathbf{X}_{n \times p}\boldsymbol{\mathbf{\beta}}_{p \times 1})^T
 (\mathbf{y}_{n \times 1} - \mathbf{X}_{n \times p}\boldsymbol{\mathbf{\beta}_{p \times 1}}) \right \}
$$

위 식에서 $\mathcal{L}(\boldsymbol{\mathbf{\beta}}) = (\mathbf{y}_{n \times 1} - \mathbf{X}_{n \times p}\boldsymbol{\mathbf{\beta}}_{p \times 1})^T
(\mathbf{y}_{n \times 1} - \mathbf{X}_{n \times p}\boldsymbol{\mathbf{\beta}}_{p \times 1})$ 라고 하면, 
$\partial \mathcal{L}(\boldsymbol{\mathbf{\beta}})/\partial \boldsymbol{\mathbf{\beta}} = 0$를 만족하는 $\boldsymbol{\mathbf{\beta}}$를 찾는 문제로 치환된다. 따라서 N-R 
알고리즘의 핵심단계는 개념적으로 아래와 같이 변형할 수 있다. 


$$
 \beta_{new} := \beta_{old} - \frac{L(\beta)'}{L(\beta)''}
$$

위 식을 행렬 형태로 일반화 하면, 


$$
\boldsymbol{\mathbf{\beta}}_{new} = \boldsymbol{\mathbf{\beta}}_{old} - [\mathbf{H}(\boldsymbol{\mathbf{\beta}}_{old})]^{-1} \nabla \mathcal{L} (\boldsymbol{\mathbf{\beta}}_{old})
$$


이고, 여기서  $\nabla \mathcal{L} (\boldsymbol{\mathbf{\beta}})$ 는 1차 도함수(gradient)라고 하고, 
$\mathbf{H}(\boldsymbol{\mathbf{\beta}}) = \nabla^2 \mathcal{L}(\boldsymbol{\mathbf{\beta}})$는 2차 도함수을 일반화한 Hessian 행렬이라고 한다. 
$\nabla \mathcal{L}(\boldsymbol{\mathbf{\beta}})$와 $\nabla^2 \mathcal{L}(\boldsymbol{\mathbf{\beta}})$은 아래와 같다. 


$$\begin{aligned}
\nabla \mathcal{L}(\boldsymbol{\mathbf{\beta}}) &= \frac{\partial \mathcal{L}(\boldsymbol{\mathbf{\beta}})}{\partial \boldsymbol{\mathbf{\beta}}} = 
\mathbf{X}^T\mathbf{X}\boldsymbol{\mathbf{\beta}} - \mathbf{X}^T\mathbf{y} \\
\nabla^2 \mathcal{L}(\boldsymbol{\mathbf{\beta}}) &= \frac{\partial^2 \mathcal{L}(\boldsymbol{\mathbf{\beta}})}{\partial \boldsymbol{\mathbf{\beta}}^2} = 
\mathbf{X}^T\mathbf{X}
\end{aligned}
$$

a) 목적함수 $\mathcal{L}(\boldsymbol{\mathbf{\beta}})$를 계산하기 위한 `obj_fun()`을 구현하기 위해 필요한 필수 인수(argument)를 정의하고 함수를 작성하시오. 


b) $\nabla \mathcal{L}(\boldsymbol{\mathbf{\beta}})$를 도출하기 위한 `grad_fun()`을 구현하기 위해 필요한 필수 인수(argument)를 정의하고 함수를 작성하시오. 


c) Hessian 행렬 $\nabla^2 \mathcal{L}(\boldsymbol{\mathbf{\beta}})$을 도출하기 위한 `hess_fun()` 함수를 구현하기 위해 필요한 필수 인수(argument)를 정의하고 함수를 작성하시오. 


d) b ~ c 에서 구현한 함수를 사용해 N-R 방법으로 선형회귀모형의 회귀계수 추정을 위한 `nr_linreg()` 함수를 구현하기 위해 필요한 필수 인수(argument)를 정의하고 함수를 작성하시오.  


e) 문제 1에서 생성한 `x`와 `y`에 대해 `lm(y ~ x)`으로 구한 회귀계수와 `nr_linreg(x, y)`로 추정한 회귀계수를 비교 하시오. 




<!-- 3. 스타 크래프트의 프로토스 종족의 유닛 다크 탬플러는 스스로를 숨길 수 있을 뿐 아니라 막강한 공격력(40 +- 3)을 갖고 있다.  -->
<!-- 다크 탬플러가 정찰 중 언덕 위에서 저그 진지를 순찰 중인 히드라리스크를 발견했다. 히드라리스크의 체력은 80 이다.  -->







