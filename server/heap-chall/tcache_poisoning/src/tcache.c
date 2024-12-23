#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_NOTE 5
#define MAX_SIZE 0x50000

char *note[MAX_NOTE];
int size[MAX_NOTE];

void print_menu() { printf("1. make\n2. edit\n3. show\n4. delete\n5. exit\n"); }

int read_int(int *n) {
  int c = scanf("%d", n);
  getchar();
  return c;
}

int check_index(int index) {
  if (index >= MAX_NOTE || index < 0) {
    return 1;
  }
  return 0;
}

void make_note() {
  int index = 0;
  printf("index > ");
  if (read_int(&index) != 1 || check_index(index)) {
    printf("Invalid index\n");
    return;
  }

  printf("size > ");
  if (read_int(&size[index]) != 1 || size[index] > MAX_SIZE ||
      size[index] < 0) {
    printf("Invalid size\n");
    return;
  }

  note[index] = malloc(size[index]);
  assert(note[index] != NULL);
  return;
}

void edit_note() {
  int index = 0;
  printf("index > ");
  if (read_int(&index) != 1 || check_index(index)) {
    printf("Invalid index\n");
    return;
  }
  if (note[index] == NULL) {
    printf("Note does not exist\n");
    return;
  }

  printf("data > ");
  fgets(note[index], size[index], stdin);
  return;
}

void show_note() {
  int index = 0;
  printf("index > ");
  if (read_int(&index) != 1 || check_index(index)) {
    printf("Invalid index\n");
    return;
  }
  if (note[index] == NULL) {
    printf("Note does not exist\n");
    return;
  }

  printf("%s", note[index]);
  return;
}

void delete_note() {
  int index = 0;
  printf("index > ");
  if (read_int(&index) != 1 || check_index(index)) {
    printf("Invalid index\n");
    return;
  }
  if (note[index] == NULL) {
    printf("Note does not exist\n");
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
    if (read_int(&num) != 1) {
      printf("Invalid input\n");
      continue;
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
