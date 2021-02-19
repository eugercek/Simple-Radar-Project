// It's not efficent at least in Java
int digitNumber(int num) {
  if ( num < 10)
    return 1;

  return 1 + digitNumber ( num / 10 );
}
