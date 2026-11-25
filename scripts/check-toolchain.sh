#!/usr/bin/env bash
set -Eeuo pipefail
required=(riscv64-linux-gnu-gcc riscv64-linux-gnu-ar riscv64-linux-gnu-readelf riscv64-linux-gnu-objdump riscv64-linux-gnu-nm qemu-riscv64 file)
for tool in "${required[@]}"; do command -v "$tool" >/dev/null || { echo "missing required tool: $tool" >&2; exit 1; }; done
compiler=${CC:-riscv64-linux-gnu-gcc}
sysroot=$($compiler -print-sysroot)
libc=$($compiler -print-file-name=libc.so.6)
test -f "$libc" || { echo "target libc not found: $libc" >&2; exit 1; }
echo "compiler: $compiler"
echo "sysroot: $sysroot"
echo "target libc: $libc"
echo "toolchain: ready"
