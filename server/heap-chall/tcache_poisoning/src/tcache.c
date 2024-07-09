#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_NOTE 5

char *note[MAX_NOTE];
int size[MAX_NOTE];

void print_menu() { printf("1. make\n2. edit\n3. show\n4. delete\n5. exit\n"); }

void make_note() {
  int index;
  printf("index > ");
  scanf("%d", &index);
  if (index >= MAX_NOTE || index < 0) {
    printf("Invalid index\n");
    return;
  }
  printf("size > ");
  scanf("%d", &size[MAX_NOTE]);
  note[index] = malloc(size[index]);
  assert(note[index] != NULL);
  return;
}

void edit_note() {
  int index;
  printf("index > ");
  scanf("%d", &index);
  if (index >= MAX_NOTE || index < 0) {
    printf("Invalid index\n");
    return;
  }
  printf("data > ");
  fgets(note[index], size[index], stdin);
  return;
}

void show_note() {
  int index;
  printf("index > ");
  scanf("%d", &index);
  if (index >= MAX_NOTE || index < 0) {
    printf("Invalid index\n");
    return;
  }
  printf("%s", note[index]);
  return;
}

void delete_note() {
  int index;
  printf("index > ");
  scanf("%d", &index);
  if (index >= MAX_NOTE || index < 0) {
    printf("Invalid index\n");
    return;
  }
  free(note[index]);
  return;
}

int main() {
  int c, num;
  setvbuf(stdout, (char *)NULL, _IONBF, 0);
  while (1) {
    print_menu();
    printf("> ");
    if (scanf("%d", &num) != 1) {
      while ((c = getchar()) != '\n' && c != EOF)
        ;
    }
    switch (num) {
    case 1:
      make_note();
      break;
    case 2:
      edit_note();
      break;
    case 3:
      show_note();
      break;
    case 4:
      delete_note();
      break;
    case 5:
      return 0;
    default:
      printf("Invalid number\n");
      break;
    }
  }
}
