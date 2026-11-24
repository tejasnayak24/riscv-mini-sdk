#ifndef MINISDK_MATH_H
#define MINISDK_MATH_H
#include <stddef.h>
int minisdk_i64_min(const long *values, size_t count, long *result);
int minisdk_i64_max(const long *values, size_t count, long *result);
long minisdk_i64_sum(const long *values, size_t count);
#endif
