move_hanoi <- function(n, from, to, via) {
  if (n == 1) {
    print(sprintf("%d 번 원판을 %s 에서 %s 로 이동", 1, from, to))
  } else {
    move_hanoi(n - 1, from, via, to)
    print(sprintf("%d 번 원판을 %s 에서 %s 로 이동", n, from, to))
    move_hanoi(n - 1, via, to, from)
  }
}
