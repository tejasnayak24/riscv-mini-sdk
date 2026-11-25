#include "minisdk/math.h"

int minisdk_i64_min(const long *values, size_t count, long *result)
{
    size_t index;
    long value;
    if (values == NULL || result == NULL || count == 0U) return -1;
    value = values[0];
    for (index = 1U; index < count; ++index) if (values[index] < value) value = values[index];
    *result = value;
    return 0;
}

int minisdk_i64_max(const long *values, size_t count, long *result)
{
    size_t index;
    long value;
    if (values == NULL || result == NULL || count == 0U) return -1;
    value = values[0];
    for (index = 1U; index < count; ++index) if (values[index] > value) value = values[index];
    *result = value;
    return 0;
}

long minisdk_i64_sum(const long *values, size_t count)
{
    size_t index;
    long result = 0L;
    if (values == NULL) return 0L;
    for (index = 0U; index < count; ++index) result += values[index];
    return result;
}
