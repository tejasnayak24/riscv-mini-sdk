#!/usr/bin/env bash
set -Eeuo pipefail
mode=${1:-build}
compiler=${CC:-riscv64-linux-gnu-gcc}
archiver=${AR:-riscv64-linux-gnu-ar}
ranlib=${RANLIB:-riscv64-linux-gnu-ranlib}
readelf=${READELF:-riscv64-linux-gnu-readelf}
objdump=${OBJDUMP:-riscv64-linux-gnu-objdump}
nm=${NM:-riscv64-linux-gnu-nm}
file_tool=${FILE:-file}
qemu=${QEMU:-qemu-riscv64}
required=("$compiler" "$archiver" "$ranlib" "$readelf" "$objdump" "$nm" "$file_tool")
if [[ "$mode" == runtime ]]; then
  required+=("$qemu")
elif [[ "$mode" != build ]]; then
  echo "usage: $0 [build|runtime]" >&2
  exit 2
fi
for tool in "${required[@]}"; do command -v "$tool" >/dev/null || { echo "missing required tool: $tool" >&2; exit 1; }; done
sysroot=$($compiler -print-sysroot)
libc=$($compiler -print-file-name=libc.so.6)
test -f "$libc" || { echo "target libc not found: $libc" >&2; exit 1; }
echo "mode: $mode"
echo "compiler: $compiler"
echo "sysroot: $sysroot"
echo "target libc: $libc"
echo "toolchain: ready"
