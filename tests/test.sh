#!/usr/bin/env bash
set -Eeuo pipefail
profile=${1:-release}
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"
pass=0
fail() { echo "FAIL: $*" >&2; exit 1; }
check() { "$@" || fail "$*"; echo "PASS: $*"; pass=$((pass + 1)); }
check ./scripts/check-toolchain.sh
check ./tests/test_math.sh
check ./tests/test_log.sh
check test -f "build/$profile/lib/libminisdk.a"
for app in hello sysinfo libdemo; do
  bin="build/$profile/bin/$app"
  check test -x "$bin"
  file_output=$(file "$bin")
  echo "$file_output" | grep -q 'RISC-V' || fail "$bin is not RISC-V"
  echo "PASS: RISC-V ELF identity for $app"
  pass=$((pass + 1))
  check riscv64-linux-gnu-readelf -h "$bin"
  output=$(make -s BUILD="$profile" run APP="$app" 2>&1) || fail "QEMU execution: $app"
  case "$app" in
    hello) grep -q 'Hello from RISC-V Mini SDK' <<<"$output" || fail "hello output" ;;
    sysinfo) grep -q '^system:' <<<"$output" || fail "sysinfo output" ;;
    libdemo) grep -q 'sum: 31' <<<"$output" || fail "libdemo output" ;;
  esac
  echo "PASS: QEMU execution and output for $app"
  pass=$((pass + 1))
done
if make -s run APP=does-not-exist >/dev/null 2>&1; then fail 'invalid app unexpectedly succeeded'; fi
echo "PASS: invalid app handling"
pass=$((pass + 1))
if make -s QEMU=missing-qemu-binary check-tools >/dev/null 2>&1; then fail 'missing dependency unexpectedly succeeded'; fi
echo "PASS: missing dependency handling"
pass=$((pass + 1))
echo "All $pass integration checks passed."
