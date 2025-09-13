#ifndef BRANCHLESS_FIZZBUZZ_H
#define BRANCHLESS_FIZZBUZZ_H

// #include <stddef.h>   // ensure size_t is defined
#include <stdint.h>   // ensure uint64_t is defined

#define MIN_BUFFER_SIZE 30

void bfb_fill_buffer(char*, uint64_t);

#endif
