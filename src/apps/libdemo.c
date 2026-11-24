#include <stdio.h>
#include "minisdk/log.h"
#include "minisdk/math.h"
#include "minisdk/string.h"
int main(void)
{
    const long values[] = {8L, -3L, 21L, 5L};
    long minimum;
    long maximum;
    char message[] = "  reusable library  ";
    minisdk_strtrim(message);
    if (minisdk_i64_min(values, 4U, &minimum) != 0 || minisdk_i64_max(values, 4U, &maximum) != 0) {
        minisdk_log(MINISDK_LOG_ERROR, "statistics failed");
        return 1;
    }
    (void)printf("message: %s\ncount: %zu\nsum: %ld\nmin: %ld\nmax: %ld\n", message, sizeof(values) / sizeof(values[0]), minisdk_i64_sum(values, 4U), minimum, maximum);
    return 0;
}
