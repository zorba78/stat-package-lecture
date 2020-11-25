split_complex <- function(z) {
  if(!is.complex(z)) 
    stop("입력값이 복소수가 아닙니다")
  re <- Re(z)
  im <- Im(z)
  return(list(real = re, imaginary = im))
}
