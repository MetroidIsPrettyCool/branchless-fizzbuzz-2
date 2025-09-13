#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "branchless_fizzbuzz.h"

int main(int argc, char* argv[]) {
    char buffer[MIN_BUFFER_SIZE] = {0};

    // could be unrolled and moved into the assembly (thereby eliminating a source of branches) if we're willing to hard
    // code the loop bound, but for the sake of the binary's size we're not gonna do that.
    for (uint64_t i = 1; i != 1000; i++) {
        bfb_fill_buffer(buffer, i);

        puts(buffer);
    }
}
