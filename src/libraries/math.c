#include "minisdk/math.h"

#include <stdint.h>

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

int minisdk_i64_sum_checked(const int64_t *values, size_t count, int64_t *result)
{
    size_t index;
    int64_t sum = 0;

    if (values == NULL || result == NULL || count == 0U) {
        return MINISDK_MATH_INVALID_ARGUMENT;
    }
    for (index = 0U; index < count; ++index) {
        if ((values[index] > 0 && sum > INT64_MAX - values[index]) ||
            (values[index] < 0 && sum < INT64_MIN - values[index])) {
            return MINISDK_MATH_OVERFLOW;
        }
        sum += values[index];
    }
    *result = sum;
    return MINISDK_MATH_OK;
}
