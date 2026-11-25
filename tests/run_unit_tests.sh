#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
host_cc=${HOST_CC:-cc}
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

"$host_cc" -std=c11 -Wall -Wextra -Wpedantic -Wshadow -Wconversion \
    -I"$root/include" "$root"/src/libraries/*.c \
    "$root/tests/unit/library_test.c" -o "$tmp_dir/library_test"
output=$("$tmp_dir/library_test" 2>&1)
grep -q '\[minisdk:INFO\] unit value: 7' <<<"$output"
grep -q '\[minisdk:WARN\] warning' <<<"$output"
grep -q '\[minisdk:ERROR\] <null format>' <<<"$output"
grep -q '\[minisdk:UNKNOWN\] invalid level' <<<"$output"
grep -q 'PASS: host library unit tests' <<<"$output"
echo "$output"
