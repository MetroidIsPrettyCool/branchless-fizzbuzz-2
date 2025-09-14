#ifndef BRANCHLESS_FIZZBUZZ_H
#define BRANCHLESS_FIZZBUZZ_H

#include <stdint.h>   // ensure uint64_t is defined

void bfb_fill_buffer(char*, uint64_t);

#define MIN_BUFFER_SIZE 30

#endif
