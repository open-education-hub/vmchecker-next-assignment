#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "Not enough arguments!\n");
        return 1;
    }

    int number = atoi(argv[1]);

    for (int i = 0; i < number; i++)
        printf("1 ");

    printf("\n");
    return 0;
}
