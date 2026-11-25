#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

cat >"$tmp_dir/log_test.c" <<'TEST'
#include <stddef.h>
#include "minisdk/log.h"

int main(void)
{
    minisdk_log(MINISDK_LOG_INFO, "info %d", 1);
    minisdk_log(MINISDK_LOG_WARN, "warning");
    minisdk_log(MINISDK_LOG_ERROR, "error");
    minisdk_log((enum minisdk_log_level)-1, "invalid");
    minisdk_log((enum minisdk_log_level)99, NULL);
    return 0;
}
TEST

cc -std=c11 -Wall -Wextra -Wpedantic -I"$root/include" \
    "$root/src/libraries/log.c" "$tmp_dir/log_test.c" -o "$tmp_dir/log_test"
"$tmp_dir/log_test" 2>"$tmp_dir/log_output"
grep -q '\[minisdk:INFO\] info 1' "$tmp_dir/log_output"
grep -q '\[minisdk:WARN\] warning' "$tmp_dir/log_output"
grep -q '\[minisdk:ERROR\] error' "$tmp_dir/log_output"
grep -q '\[minisdk:UNKNOWN\] invalid' "$tmp_dir/log_output"
grep -q '\[minisdk:UNKNOWN\] <null format>' "$tmp_dir/log_output"
echo "PASS: logging input and level tests"
