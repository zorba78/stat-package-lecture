---
output: html_document
editor_options: 
  chunk_output_type: console
---


# 시뮬레이션 {#Simulation}

> **Sketch**
>
> - 시뮬레이션..시뮬레이션??..시뮬레이션!!
> - 통계학에서 시뮬레이션이 왜 필요할까? 
> - 중요한 기초통계 이론을 눈으로 확인할 수 있을까?


<img src="figures/ch3-uni-clt.gif" width="100%" style="display: block; margin: auto;" />


## 시뮬레이션(모의실험)의 의미


**알반적 의미**


현실세계에서는 시간 및 비용 등의 문제로 실현하기 어렵거나 불가능한 시스템을 모형을 통해 실제 시스템을 모사함으로써 현상에 대한 문제를 이해하고자 하는 목적으로 고안한 일련의 방법


**시뮬레이션의 활용 사례**

- 군사 모의실험
- 비행 모의실험
- 선거 모의실험
- 민방위 훈련
- ...


**통계적 모의실험(statistical or stochastic simulation)**


통계학의 표본이론과 확률론에 근간을 두고 난수(random number)와 임의표본(random sample)을 이용해 어떤 결과나 문제의 해를 근사해 실제 이론으로 도출한 해와 비교함. 이러한 형태의 모의실험 방법을 몬테칼로 시뮬레이션(Monte Carlo simulation)이라고 함. 


> 통계적 모의실험에 Monte carlo 라는 명칭이 붙게된 계기는 2차 세계대전 당시 미국의 원자폭탄 계발계획인 Manhattan 프로젝트에서 중성자의 특성을 연구하기 위한 모의실험의 명칭에 모나코의 유명한 도박 도시 Monte Carlo 이름을 붙힌 것에서 유래함. 


**통계적 모의실험의 특징**

- 특정 분포를 따르는 확률변수의 관찰값이 필요
- 반복적으로 수많은 난수를 생성해야 하기 때문에 컴퓨터의 사용이 필수적
- 기본적으로 통계학의 가장 기본적 개념인 **대수의 법칙(law of the large number)**을 활용




<div class="figure" style="text-align: center">
<img src="figures/scheme-stat.jpg" alt="모집단, 표본, 통계량, 표본분포 관계" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-2)모집단, 표본, 통계량, 표본분포 관계</p>
</div>

