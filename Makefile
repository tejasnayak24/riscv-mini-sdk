include config/toolchain.mk

APP_NAMES := hello sysinfo libdemo
LIB_SOURCES := $(wildcard src/libraries/*.c)
LIB_OBJECTS := $(patsubst src/%.c,build/$(BUILD)/%.o,$(LIB_SOURCES))
LIBRARY := build/$(BUILD)/lib/libminisdk.a
APP_OBJECTS := $(patsubst %,build/$(BUILD)/apps/%.o,$(APP_NAMES))
APP_BINS := $(patsubst %,build/$(BUILD)/bin/%,$(APP_NAMES))
PACKAGE_DIR := packages/riscv-mini-sdk-$(BUILD)

.PHONY: all build debug release library examples clean run test inspect package check-tools help
.SECONDARY: $(LIB_OBJECTS) $(APP_OBJECTS)
all: build
build: check-tools library examples
debug:; $(MAKE) BUILD=debug build
release:; $(MAKE) BUILD=release build

check-tools:
	@missing=0; for tool in "$(CC)" "$(AR)" "$(RANLIB)" "$(READELF)" "$(OBJDUMP)" "$(NM)" "$(FILE)" "$(QEMU)"; do command -v "$$tool" >/dev/null 2>&1 || { echo "error: required tool not found: $$tool" >&2; missing=1; }; done; if [ "$$missing" -ne 0 ]; then echo "Install the RISC-V GCC/binutils and QEMU user-mode packages, or override tool variables." >&2; exit 1; fi
	@test -n "$(SYSROOT)" || { echo "error: cross compiler returned an empty sysroot" >&2; exit 1; }
	@libc="$(shell $(CC) -print-file-name=libc.so.6 2>/dev/null)"; test -f "$$libc" || { echo "error: target libc not found: $$libc" >&2; exit 1; }
	@echo "toolchain: $(CC), arch=$(ARCH), abi=$(ABI), sysroot=$(SYSROOT)"
	@echo "qemu runtime prefix: $(QEMU_LD_PREFIX)"

library: $(LIBRARY)
examples: $(APP_BINS)
$(LIBRARY): $(LIB_OBJECTS) | build/$(BUILD)/lib
	$(AR) rcs $@ $^
	$(RANLIB) $@
build/$(BUILD)/bin/%: build/$(BUILD)/apps/%.o $(LIBRARY) | build/$(BUILD)/bin
	$(CC) $(COMMON_LDFLAGS) $(LDFLAGS) -o $@ $< $(LIBRARY) $(LDLIBS)
build/$(BUILD)/libraries/%.o: src/libraries/%.c | build/$(BUILD)/libraries
	$(CC) $(COMMON_CPPFLAGS) $(COMMON_CFLAGS) $(CFLAGS) -c $< -o $@
build/$(BUILD)/apps/%.o: src/apps/%.c | build/$(BUILD)/apps
	$(CC) $(COMMON_CPPFLAGS) $(COMMON_CFLAGS) $(CFLAGS) -c $< -o $@
build/$(BUILD)/lib build/$(BUILD)/bin build/$(BUILD)/libraries build/$(BUILD)/apps:
	mkdir -p $@

run: build
	@name="$(APP)"; test -n "$$name" || { echo "usage: make run APP=hello" >&2; exit 2; }; test -x "build/$(BUILD)/bin/$$name" || { echo "error: unknown or unbuilt app '$$name'" >&2; exit 2; }; "$(FILE)" "build/$(BUILD)/bin/$$name" | grep -q 'RISC-V' || { echo "error: '$$name' is not a RISC-V executable" >&2; exit 1; }; "$(QEMU)" $(QEMU_OPTS) -L "$(QEMU_LD_PREFIX)" "build/$(BUILD)/bin/$$name"
test: build
	@./tests/test.sh "$(BUILD)"
inspect: build
	@name="$(APP)"; test -n "$$name" || { echo "usage: make inspect APP=hello" >&2; exit 2; }; bin="build/$(BUILD)/bin/$$name"; test -f "$$bin" || { echo "error: binary not found: $$bin" >&2; exit 2; }; "$(FILE)" "$$bin"; "$(READELF)" -h "$$bin"; "$(READELF)" -d "$$bin" 2>/dev/null || true; "$(OBJDUMP)" -d "$$bin" | head -80; "$(NM)" -C "$$bin" | head -40

package: build
	@rm -rf "$(PACKAGE_DIR)"; mkdir -p "$(PACKAGE_DIR)/bin" "$(PACKAGE_DIR)/docs"; cp build/$(BUILD)/bin/* "$(PACKAGE_DIR)/bin/"; cp README.md docs/architecture.md "$(PACKAGE_DIR)/docs/"; { echo "name: riscv-mini-sdk"; echo "build: $(BUILD)"; echo "arch: $(ARCH)"; echo "abi: $(ABI)"; echo "compiler: $(CC)"; } > "$(PACKAGE_DIR)/SDK-METADATA"; tar -czf "packages/riscv-mini-sdk-$(BUILD).tar.gz" -C packages "riscv-mini-sdk-$(BUILD)"; rm -rf "$(PACKAGE_DIR)"; echo "created packages/riscv-mini-sdk-$(BUILD).tar.gz"
clean:
	rm -rf build/release build/debug packages/riscv-mini-sdk-release packages/riscv-mini-sdk-debug packages/riscv-mini-sdk-release.tar.gz packages/riscv-mini-sdk-debug.tar.gz
-include $(LIB_OBJECTS:.o=.d) $(APP_OBJECTS:.o=.d)
help:
	@echo "RISC-V Mini SDK targets:"; echo "  make all/build       Build library and all applications"; echo "  make debug/release   Select build profile"; echo "  make library         Build libminisdk.a"; echo "  make examples        Build hello, sysinfo, and libdemo"; echo "  make run APP=hello  Execute a target binary under QEMU"; echo "  make test            Run integration tests"; echo "  make inspect APP=x  Inspect ELF, dependencies, disassembly, symbols"; echo "  make package         Create a portable application package"; echo "  make clean           Remove generated artifacts"
