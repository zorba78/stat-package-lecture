buffon_needle_draw <- function(l = 0.8, # 바늘의 길이
                               d = 1,   # 두 평생선 간 간격
                               col = c("lightgray", "red", "gray", "red", "blue", "black", "red"), 
                               expand = 0.4, 
                               type = "l", ...) {
  # 반복 초기화
  j <- 1; n <- 0
  x <- y <- x0 <- y0 <- theta <- a <- rep(NA, ani.options("nmax"))

  plot(1, xlim = c(-0.5*l, 1.5*l), 
       ylim = c(0, 2*d), 
       type = "n", 
       xlab = "", ylab = "", axes = FALSE)
  axis(1, c(0, l), c("", ""), tcl = -1)
  axis(1, 0.5 * l, "L", font = 3, tcl = 0, cex.axis = 1.5, 
       mgp = c(0, 0.5, 0))
  axis(2, c(0.5, 1.5) * d, c("", ""), tcl = -1)
  axis(2, d, "D", font = 3, tcl = 0, cex.axis = 1.5, mgp = c(0, 0.5, 0))
  box()
  bd <- par("usr") # 실제 device plot 영역 상 x-y 좌표 시작 끝 점 정보 반환
  rect(bd[1], 0.5 * d, bd[2], 1.5 * d, col = col[1])
  abline(h = c(0.5 * d, 1.5 * d), lwd = 2)
  
  while (j <= length(x)) {
    dev.hold()
    # 그림 1: 부폰의 바늘 실험: 바늘과 평행선
    # 실제 바늘이 평행선 안에 떨어지는 모습 모사
    theta[j] <- runif(1, 0, pi)
    a[j] <- runif(1, 0, d/2)
    y[j] <- sample(c(0.5 * d + a[j], 1.5 * d - a[j]), 1)
    x[j] <- runif(1, 0, 1)
    # 바늘이 떨어졌을 때 수평선과 이루는 각도 반영
    x0[j] <- l/2 * cos(theta[j])
    y0[j] <- l/2 * sin(theta[j])
    segments(x[j] - x0[j], y[j] - y0[j], 
             x[j] + x0[j], y[j] + y0[j], 
             col = col[2])
    ani.pause()
    j <- j + 1
  }
}
