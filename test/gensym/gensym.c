#include <stdio.h>
#include <time.h>

void foo(void)
{
  time_t time1 = time(NULL);
  struct tm *time2 = localtime(&time1);
  char time3[64];
  char time4[64];
  static char prev[64];
  static unsigned long count = 0;

  strftime(time3, 60, "s%Y%m%d%H%M%S", time2);

  if (strcmp(time3, prev) == 0) {
    count++;
  }
  else {
    strcpy(prev, time3);
    count = 0;
  }
  sprintf(time4, "%s%u", time3, count);

  printf("%s\n", time4);
}


void main(void)
{
  foo();
  foo();
  foo();
  foo();
  foo();
}
