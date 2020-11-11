newton_raphson_test <- function(FUN, # 함수
                                x0 = 1, # 초기값
                                max_iters = 5000, # 최대 반복 횟수
                                tol = 1.0e-7,
                                range = c(-Inf, Inf),
                                ...)
{
  iters <- 1; d <- tol;
  grads <- deriv(as.expression(body(FUN)), "x", function.arg = TRUE)
  x <- c(x0, x0 - FUN(x0)/grads)
  gap <- x[2]
  
  while(iters < max_iters & abs(gap) > tol) {
    # browser()
    grads <- (FUN(x0 + d) - FUN(x0))/d
    x_new <- x0 - FUN(x0)/grads
    gap <- FUN(x_new)
    # x_new 가 범위를 벗어난 경우 처리
    if (x_new <= range[1]) x_new <- range[1]
    if (x_new >= range[2]) x_new <- range[2]
    iters <- iters + 1
    x0 <- x_new
  }
  
  if (x_new == range[1] | x_new == range[2])
    warning("마지막 점이 x 범위의 경계선 상에 있습니다.")
  if (iters > max_iters)
    warning("최대 반복 때 까지 해를 찾지 못했습니다.")
  cat("x 가", x_new, "일 때 함수값:", FUN(x_new), "\n")
  return(list(solution = x_new, iteration = iters))
  
}



n <- 30; 
b0 <- 1.3; b1 <- 2.5
mu_x <- 2; sig_x <- sqrt(4)
mu_e <- 0; sig_e <- sqrt(3)
x <- rnorm(n, mu_x, sig_x)
e <- rnorm(n, mu_e, sig_e)
y <- b0 + b1*x + e

obj_fun <- function(x, y, beta) {
  n <- length(x)
  xmat <- cbind(1, x)
  xb.vec <- drop(xmat %*% beta)
  sum((y - xb.vec)^2)/(2 * n)
}

grad_fun <- function(x, y, beta) {
  n <- length(x)
  xmat <- cbind(1, x)
  xb.vec <- drop(xmat %*% beta)
  (t(xmat) %*% xb.vec - t(xmat) %*% y) / n

}

hess_fun <- function(x, y, beta) {
  n <- length(x)
  xmat <- cbind(1, x)
  t(xmat) %*% xmat / n
}


nr_linreg <- function(x, y, 
                      max_iters = 1000, 
                      tol = 1e-7) {
  iters <- 0
  bvec <- rep(0, 2)
  bdist <- Inf

  while(iters < max_iters & bdist > tol) {
    grads <- grad_fun(x, y, bvec)
    hessian <- hess_fun(x, y, bvec)
    bnew <- bvec - solve(hessian) %*% grads
    bdist <- sqrt(sum((bvec - bnew)^2))
    iters <- iters + 1
    bvec <- bnew
  }
  return(bvec)
}

nr_linreg(x, y)
lm(y ~ x)


gd_linreg <- function(x, y, 
                      max_iters = 1000, 
                      bvec = c(0, 0), 
                      alpha = 0.1, 
                      tol = 1e-10) {
  # browser()
  iters <- 0
  cost_trace <- rep(NA, max_iters)
  berror <- Inf
  while(iters <= max_iters & berror > tol) {
    g <- grad_fun(x, y, bvec)
    bnew <- bvec - alpha * g
    berror <- sqrt(sum(bvec - bnew)^2)
    iters <- iters + 1
    bvec <- bnew
    cost_trace[iters] <- obj_fun(x, y, bvec)
  }
  return(list(beta = bvec, cost = cost_trace))
}

gd_linreg(x, y)


# sample and function definition
loss.fun = function(y.vec,x.mat,b.vec){
  ret = sum((y.vec-drop(x.mat%*%b.vec))^2)/length(y.vec)
  return(ret)
}

grad.fun = function(y.vec,x.mat,b.vec){
  xb.vec = drop(x.mat%*%b.vec)
  ret = -2*drop(t(x.mat)%*%(y.vec-xb.vec))/length(y.vec)
  return(ret)
}

set.seed(1); n = 100; 
x.mat = cbind(1,rnorm(n,1,1))
b.vec = c(5,-5) 
y.vec = drop(x.mat)%*%b.vec+rnorm(n)

# plot
loss.mat = matrix(0,50,50)
g.vec = seq(-30,30,length.out=50)
for(i in 1:50){
  for(j in 1:50){
    b.vec = c(g.vec[i],g.vec[j])
    loss.mat[i,j] = loss.fun(y.vec,x.mat,b.vec)
  }
}
contour(g.vec,g.vec,loss.mat,nlevels=50)



get.fam.fun = function(fam){
  if(fam=="gaussian"){ # linear regression
    obj.fun = function(y.vec,x.mat,b.vec){
      xb.vec = drop(x.mat%*%b.vec)
      return(sum((xb.vec-y.vec)^2)/length(y.vec)/2)
    }
    obj.grad.fun = function(y.vec,x.mat,b.vec){
      xb.vec = drop(x.mat%*%b.vec)
      return(drop(t(x.mat)%*%(xb.vec-y.vec)/length(y.vec)))
    }
    obj.hess.fun = function(y.vec,x.mat,b.vec){
      return(t(x.mat)%*%x.mat/length(y.vec))
    }
  } else if(fam=="binomial"){ # poisson regression
    obj.fun = function(y.vec,x.mat,b.vec){
      xb.vec = pmin(drop(x.mat%*%b.vec),700)
      return(sum(log(1+exp(xb.vec))-y.vec*xb.vec)/length(y.vec))
    }
    obj.grad.fun = function(y.vec,x.mat,b.vec){
      xb.vec = pmin(drop(x.mat%*%b.vec),700); 
      exb.vec = exp(xb.vec)
      p.vec = exb.vec/(1+exb.vec)
      return(drop(t(x.mat)%*%(p.vec-y.vec)/length(y.vec)))
    }
    obj.hess.fun = function(y.vec,x.mat,b.vec){
      xb.vec = pmin(drop(x.mat%*%b.vec),700)
      exb.vec = exp(xb.vec)
      p.vec = exb.vec/(1+exb.vec); 
      d.vec = p.vec*(1-p.vec) 
      d.vec[d.vec<1e-7] = 1e-7
      return(t(x.mat)%*%diag(d.vec)%*%x.mat/length(y.vec))
    }
  } else if(fam=="poisson"){ # poisson regression
    print("Sooooory!! do by your self as your homework")
  }
  return(list(obj.fun=obj.fun,obj.grad.fun=obj.grad.fun,obj.hess.fun=obj.hess.fun))
}

nr.fun = function(y.vec,x.mat,iter.max=100,b.eps=1e-10,fam="gaussian"){                                  
  obj.fun = get.fam.fun(fam)[[1]]; obj.grad.fun = get.fam.fun(fam)[[2]]; obj.hess.fun = get.fam.fun(fam)[[3]]
  p = dim(x.mat)[2]
  b.vec = rep(0,p)
  for(iter in 1:iter.max){
    hess.mat = obj.hess.fun(y.vec,x.mat,b.vec); grad.vec = obj.grad.fun(y.vec,x.mat,b.vec); 
    nb.vec = b.vec-solve(hess.mat)%*%grad.vec; if(sum(abs(nb.vec-b.vec))<b.eps) break; b.vec = nb.vec
  }
  return(drop(b.vec))
}

