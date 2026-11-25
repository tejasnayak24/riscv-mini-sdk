#ifndef MINISDK_MATH_H
#define MINISDK_MATH_H
#include <stddef.h>
#include <stdint.h>

#define MINISDK_MATH_OK 0
#define MINISDK_MATH_INVALID_ARGUMENT (-1)
#define MINISDK_MATH_OVERFLOW (-2)

/* Existing helpers retain their long-based API for source compatibility. */
int minisdk_i64_min(const long *values, size_t count, long *result);
int minisdk_i64_max(const long *values, size_t count, long *result);
long minisdk_i64_sum(const long *values, size_t count);

/*
 * Adds count signed 64-bit values without wrapping.
 * Returns MINISDK_MATH_OK, MINISDK_MATH_INVALID_ARGUMENT, or
 * MINISDK_MATH_OVERFLOW. On failure, result is not modified.
 */
int minisdk_i64_sum_checked(const int64_t *values, size_t count, int64_t *result);
#endif
