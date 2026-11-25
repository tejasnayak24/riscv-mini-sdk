#include <assert.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "minisdk/log.h"
#include "minisdk/math.h"
#include "minisdk/string.h"
#include "minisdk/sysinfo.h"

static void test_math(void)
{
    const long values[] = {8L, -3L, 21L, 5L};
    const int64_t checked[] = {INT64_MAX, -1};
    long result;
    int64_t checked_result;

    assert(minisdk_i64_min(values, 4U, &result) == 0 && result == -3L);
    assert(minisdk_i64_max(values, 4U, &result) == 0 && result == 21L);
    assert(minisdk_i64_min(NULL, 0U, &result) == -1);
    assert(minisdk_i64_max(values, 0U, &result) == -1);
    assert(minisdk_i64_sum(values, 4U) == 31L);
    assert(minisdk_i64_sum(NULL, 4U) == 0L);
    assert(minisdk_i64_sum_checked(checked, 2U, &checked_result) == MINISDK_MATH_OK);
    assert(checked_result == INT64_MAX - 1);
}

static void test_string(void)
{
    char text[] = "  hello, SDK  ";
    assert(minisdk_strnlen(text, sizeof(text)) == sizeof(text) - 1U);
    assert(minisdk_strnlen(NULL, 4U) == 0U);
    assert(minisdk_streq("sdk", "sdk") != 0);
    assert(minisdk_streq("sdk", "SDK") == 0);
    assert(minisdk_streq(NULL, NULL) != 0);
    minisdk_strtrim(text);
    assert(strcmp(text, "hello, SDK") == 0);
    minisdk_strtrim(NULL);
}

static void test_sysinfo(void)
{
    char system_name[128];
    char release[128];
    char too_small[1] = {'x'};
    assert(minisdk_system_name(system_name, sizeof(system_name)) == 0);
    assert(system_name[0] != '\0');
    assert(minisdk_system_release(release, sizeof(release)) == 0);
    assert(release[0] != '\0');
    assert(minisdk_system_name(NULL, sizeof(system_name)) == -1);
    assert(minisdk_system_release(too_small, sizeof(too_small)) == -1);
    assert(minisdk_process_id() == (long)getpid());
}

static void test_log(void)
{
    minisdk_log(MINISDK_LOG_INFO, "unit value: %d", 7);
    minisdk_log(MINISDK_LOG_WARN, "warning");
    minisdk_log(MINISDK_LOG_ERROR, NULL);
    minisdk_log((enum minisdk_log_level)-1, "invalid level");
}

int main(void)
{
    test_math();
    test_string();
    test_sysinfo();
    test_log();
    puts("PASS: host library unit tests");
    return 0;
}
