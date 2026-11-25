#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

cat >"$tmp_dir/math_test.c" <<'TEST'
#include <assert.h>
#include <stdint.h>
#include <limits.h>
#include "minisdk/math.h"

int main(void)
{
    const int64_t positive[] = {1, 2, 3};
    const int64_t negative[] = {-1, -2, -3};
    const int64_t mixed[] = {INT64_MAX, -1};
    const int64_t positive_overflow[] = {INT64_MAX, 1};
    const int64_t negative_overflow[] = {INT64_MIN, -1};
    int64_t result = 99;

    assert(minisdk_i64_sum_checked(positive, 3U, &result) == MINISDK_MATH_OK && result == 6);
    assert(minisdk_i64_sum_checked(negative, 3U, &result) == MINISDK_MATH_OK && result == -6);
    assert(minisdk_i64_sum_checked(mixed, 2U, &result) == MINISDK_MATH_OK && result == INT64_MAX - 1);
    result = 99;
    assert(minisdk_i64_sum_checked(positive_overflow, 2U, &result) == MINISDK_MATH_OVERFLOW && result == 99);
    assert(minisdk_i64_sum_checked(negative_overflow, 2U, &result) == MINISDK_MATH_OVERFLOW && result == 99);
    assert(minisdk_i64_sum_checked(NULL, 0U, &result) == MINISDK_MATH_INVALID_ARGUMENT && result == 99);
    assert(minisdk_i64_sum_checked(positive, 0U, &result) == MINISDK_MATH_INVALID_ARGUMENT && result == 99);
    assert(minisdk_i64_sum_checked(positive, 3U, NULL) == MINISDK_MATH_INVALID_ARGUMENT);
    return 0;
}
TEST

cc -std=c11 -Wall -Wextra -Wpedantic -I"$root/include" \
    "$root/src/libraries/math.c" "$tmp_dir/math_test.c" -o "$tmp_dir/math_test"
"$tmp_dir/math_test"
echo "PASS: mathematical utility boundary tests"
