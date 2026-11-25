#!/usr/bin/env bash
set -Eeuo pipefail

profile=${1:-release}
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
archive="$root/packages/riscv-mini-sdk-$profile.tar.gz"
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

test -f "$archive"
listing=$(tar -tzf "$archive")
for expected in \
    "riscv-mini-sdk-$profile/bin/hello" \
    "riscv-mini-sdk-$profile/bin/sysinfo" \
    "riscv-mini-sdk-$profile/bin/libdemo" \
    "riscv-mini-sdk-$profile/lib/libminisdk.a" \
    "riscv-mini-sdk-$profile/include/minisdk/math.h" \
    "riscv-mini-sdk-$profile/include/minisdk/log.h" \
    "riscv-mini-sdk-$profile/SDK-METADATA" \
    "riscv-mini-sdk-$profile/docs/README.md"; do
    grep -qx "$expected" <<<"$listing"
done
if grep -Eq '\.(o|d|so)$' <<<"$listing"; then
    echo "package contains generated intermediate files" >&2
    exit 1
fi
tar -xzf "$archive" -C "$tmp_dir"
test -f "$tmp_dir/riscv-mini-sdk-$profile/lib/libminisdk.a"
test -f "$tmp_dir/riscv-mini-sdk-$profile/include/minisdk/sysinfo.h"
test "$(find "$tmp_dir/riscv-mini-sdk-$profile/bin" -maxdepth 1 -type f | wc -l)" -eq 3
echo "PASS: package contents and extraction"
