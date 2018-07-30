
#include <stdio.h>
#include <stdlib.h>

int main() {
  setbuf(stdout, 0);
  puts("Hello World!");
  system("sh");
  return 0;
}