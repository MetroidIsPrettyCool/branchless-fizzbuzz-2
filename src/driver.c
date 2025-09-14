#include <stdio.h>
#include <stdlib.h>

#include <stdint.h>

#include "branchless_fizzbuzz.h"

int main(int argc, char* argv[]) {
    char buffer[MIN_BUFFER_SIZE] = {0};

    bfb_fill_buffer(buffer, UINT64_MAX);

    puts(buffer);

    /* for (uint64_t i = 1; i != 1000; i++) { */
    /*     bfb_fill_buffer(buffer, i); */

    /*     puts(buffer); */
    /* } */
}
