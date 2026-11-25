# RISC-V Mini SDK

RISC-V Mini SDK is a small toolkit for building 64-bit RISC-V Linux C programs
on an x86-64 host. It cross-compiles with GCC, archives a reusable C library,
validates ELF files, runs them under QEMU, and packages applications.

## Architecture

```text
src/apps + src/libraries -> Makefile -> RISC-V ELF -> qemu-riscv64 -> program
                                  \-> libminisdk.a
```

See [docs/architecture.md](docs/architecture.md) for the pipeline and sysroot
details.

## Prerequisites

Ubuntu/Debian packages equivalent to `gcc-riscv64-linux-gnu`,
`binutils-riscv64-linux-gnu`, `qemu-user`, GNU Make, and `file` are required.
The SDK discovers tools through `PATH`; override `CC`, `SYSROOT`, `QEMU`, or
`QEMU_LD_PREFIX` when using a custom installation.

```sh
./scripts/check-toolchain.sh
```

## Usage

```sh
make                 # release build of library and all examples
make debug           # debug profile
make run APP=hello   # execute through qemu-riscv64
make run APP=sysinfo
make run APP=libdemo
make test
make inspect APP=hello
make package
make clean
```

The compact interface delegates to Make:

```sh
./sdk build hello
./sdk run hello
./sdk inspect hello
./sdk test
./sdk package
./sdk clean
```

`make library` builds `build/release/lib/libminisdk.a`; all applications link
against it. `SYSROOT` can point to a complete target sysroot. Do not point it
at host x86-64 libraries or an incomplete directory.

`make package` creates an archive containing the three application binaries,
`libminisdk.a`, public headers, metadata, and documentation under predictable
`bin/`, `lib/`, `include/`, and `docs/` directories. Build objects and
dependency files are never packaged.

## Layout

```text
config/   cross-toolchain defaults
include/  public libminisdk headers
src/      library and application C sources
scripts/  environment checks
tests/    integration tests
build/    ignored objects, dependencies, archives, and executables
packages/ ignored generated tarballs
```

## Inspection and troubleshooting

`make inspect APP=hello` uses `file`, `readelf`, `objdump`, and `nm`. A QEMU
error about the ELF interpreter usually means the target runtime prefix is
wrong; inspect `riscv64-linux-gnu-gcc -print-file-name=libc.so.6` and set
`QEMU_LD_PREFIX` to its parent target root. A missing header or `-lc` indicates
an invalid custom `SYSROOT`. An executable that does not report RISC-V is not
run by the SDK.

## Tests

`make test` checks toolchain detection, library/application outputs, RISC-V ELF
headers, QEMU execution and output, and invalid application handling. Tests
require the stated cross-toolchain and QEMU runtime; they fail clearly when a
dependency is unavailable.

## License

MIT; see [LICENSE](LICENSE).
