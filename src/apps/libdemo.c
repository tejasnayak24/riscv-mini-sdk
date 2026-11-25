#include <stdio.h>
#include <inttypes.h>
#include <stdint.h>
#include "minisdk/log.h"
#include "minisdk/math.h"
#include "minisdk/string.h"
int main(void)
{
    const long values[] = {8L, -3L, 21L, 5L};
    long minimum;
    long maximum;
    const int64_t checked_values[] = {INT64_MAX, -1};
    int64_t checked_sum;
    char message[] = "  reusable library  ";
    minisdk_strtrim(message);
    if (minisdk_i64_min(values, 4U, &minimum) != 0 || minisdk_i64_max(values, 4U, &maximum) != 0) {
        minisdk_log(MINISDK_LOG_ERROR, "statistics failed");
        return 1;
    }
    if (minisdk_i64_sum_checked(checked_values, 2U, &checked_sum) != MINISDK_MATH_OK) {
        minisdk_log(MINISDK_LOG_ERROR, "checked sum failed");
        return 1;
    }
    (void)printf("message: %s\ncount: %zu\nsum: %ld\nchecked sum: %" PRId64 "\nmin: %ld\nmax: %ld\n", message, sizeof(values) / sizeof(values[0]), minisdk_i64_sum(values, 4U), checked_sum, minimum, maximum);
    return 0;
}
