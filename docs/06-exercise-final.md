---
output: html_document
editor_options: 
  chunk_output_type: console
---
# 2020년 2학기 기말고사 대비 연습문제


1. 다음과 같은 두 가지 게임을 고려해보자. 

> 게임 규칙
> 
>- A 게임: 공정한 동전을 던졌을 때 앞면이 나오면 2000 원을 얻고, 뒷면이 나오면 1500 원을 잃음.
>- B 게임: 공정한 주사위를 던졌을 때, 6이 나오면 12000 원을 얻음. 2, 3, 4, 5 가 나오면 비김. 1이 나오면 11000 원을 잃음. 


a. 만약 A와 B 중 단 한 번만 플레이 할 수 있다면 어떤 게임을 선택할 것이고 그 이유는 무엇인지 기술하시오.


b. A와 B 게임을 각각 무한히 플레이 했을 때 얻을 수 있는 금액을 Rmarkdown 수식으로 나타내시오. 


c. A와 B 둘 중 하나를 10000 번 플레이 할 수 있다면 어떤 선택을 할 지를 결정하기 위해 모의실험을 통해 확인해보기로 하자. 
   - A 게임 플레이 시 예상되는 상금의 가치를 추정하기 위한 시뮬레이션 함수 `gameA()`를 작성 하시오. 
   - B 게임 플레이 시 예상되는 상금의 가치를 추정하기 위한 시뮬레이션 함수 `gameB()`를 작성 하시오. 
   

d. 어떤 게임이 이익의 측면에서 더 나은 게임인지 위 모의실험 결과에 근거하여 기술하시오. 


\BeginKnitrBlock{rmdnote}<div class="rmdnote">**함수 생성 시 필수 매개변수(arguments)**

1. `reps`: 반복 횟수를 지정(초기값은 10000)
2. `seed`: 시드 번호 지정(초기값은 `NULL`)
3. `verbose`: 참인 경우 "A(또는) B 게임을 했을 때 기대되는 수익은 ### 원임."이 콘솔 상에 출력


**함수의 구성**

1. `seed` 값이 `NULL`이 아닌 경우 seed 값 지정
2. 함수의 최종 산출물인 기댓값을 반환(return)
</div>\EndKnitrBlock{rmdnote}

   


```r
gameA <- function(reps = 10000, seed = NULL, 
                  verbose = TRUE) {
  if (!is.null(seed)) set.seed(seed)
  price <- c(2000, -1500)
  pcoin <- c(1/2, 1/2)
  win <- sample(price, size = reps, 
                replace = TRUE, 
                prob = pcoin)
  if (verbose) 
    cat("A 게임을 했을 때 기대되는 수익은 ", 
        mean(win), ".\n", sep = "")
  invisible(mean(win))
}

gameB <- function(reps = 10000, seed = NULL, 
                  verbose = TRUE) {
  if (!is.null(seed)) set.seed(seed)
  price <- c(12000, 0, -11000)
  pdice <- c(1/6, 2/3, 1/6)
  win <- sample(price, size = reps, 
                replace = TRUE, 
                prob = pdice)
  if (verbose) 
    cat("B 게임을 했을 때 기대되는 수익은 ", 
        mean(win), ".\n", sep = "")
  invisible(mean(win))

}

gameA(reps = 50000, seed = 1234, 
      verbose = TRUE)
```

```
## A 게임을 했을 때 기대되는 수익은 252.17.
```

```r
gameB(reps = 50000, seed = 1234, 
      verbose = TRUE)
```

```
## B 게임을 했을 때 기대되는 수익은 151.38.
```



   
