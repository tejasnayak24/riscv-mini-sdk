# Build architecture

```text
C source -> riscv64-linux-gnu-gcc -> RISC-V object files
          -> libminisdk.a + linker -> RISC-V 64-bit Linux ELF
          -> qemu-riscv64 -L target runtime prefix -> execution
```

The cross-compiler translates code for `rv64gc` and the `lp64d` ABI; it is not
the host compiler. Each source file is compiled to an object file, and the
library objects are archived into `libminisdk.a`. The linker combines that
static archive with glibc from the target sysroot to create a dynamically
linked RISC-V ELF executable.

The sysroot supplies target headers and libraries. By default the SDK uses the
sysroot and library search paths reported by the installed cross-compiler. Set
`SYSROOT=/path/to/target-sysroot` to use another complete target sysroot; the
SDK validates that it contains target libc. QEMU's `-L` prefix supplies the
target dynamic loader and shared libraries at runtime, and is derived from the
compiler's target libc location unless `QEMU_LD_PREFIX` is set.
