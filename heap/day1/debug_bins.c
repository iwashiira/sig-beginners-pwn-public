#include <stdlib.h>
#include <string.h>

#define TCACHE_COUNT 7

int main() {
  void *tcache_ptr[TCACHE_COUNT];
  for (int i = 0; i < 7; i++) {
    tcache_ptr[i] = malloc(0x28);
  }
  void *p1 = malloc(0x28);
  void *p2 = malloc(0x28);
  strcpy(p1, "p1\n");
  strcpy(p2, "p2\n");
  // fill tcache
  for (int i = 0; i < 7; i++) {
    free(tcache_ptr[i]);
  }
  // free chunk to fastbins
  free(p1);
  free(p2);

  // mmap
  p1 = malloc(0x20bc0 + 0x60);
  strcpy(p1, "p1\n");
  free(p1);
  return 0;
}
