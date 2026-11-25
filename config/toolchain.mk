# Cross-toolchain configuration. Every value can be overridden by the caller.
CROSS ?= riscv64-linux-gnu-
ifeq ($(origin CC),default)
CC := $(CROSS)gcc
endif
ifeq ($(origin AR),default)
AR := $(CROSS)ar
endif
ifeq ($(strip $(RANLIB)),)
RANLIB := $(CROSS)ranlib
endif
ifeq ($(origin READELF),undefined)
READELF := $(CROSS)readelf
endif
ifeq ($(origin OBJDUMP),undefined)
OBJDUMP := $(CROSS)objdump
endif
ifeq ($(origin NM),undefined)
NM := $(CROSS)nm
endif
ifeq ($(origin FILE),undefined)
FILE := file
endif
ifeq ($(origin QEMU),undefined)
QEMU := qemu-riscv64
endif

ARCH ?= rv64gc
ABI ?= lp64d
SYSROOT ?= $(shell $(CC) -print-sysroot 2>/dev/null)
QEMU_LD_PREFIX ?= $(shell dirname "$(shell dirname "$(shell $(CC) -print-file-name=libc.so.6 2>/dev/null)")")
QEMU_OPTS ?=

COMMON_CFLAGS := -march=$(ARCH) -mabi=$(ABI) -std=c11 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wstrict-prototypes -MMD -MP
COMMON_CPPFLAGS := -Iinclude
COMMON_LDFLAGS := -march=$(ARCH) -mabi=$(ABI)
ifneq ($(strip $(SYSROOT)),)
COMMON_CFLAGS += --sysroot=$(SYSROOT)
COMMON_LDFLAGS += --sysroot=$(SYSROOT)
endif

BUILD ?= release
ifeq ($(BUILD),debug)
CFLAGS += -O0 -g3
else ifeq ($(BUILD),release)
CFLAGS += -O2 -g0 -DNDEBUG
else
$(error BUILD must be either release or debug (received '$(BUILD)'))
endif

export CC AR RANLIB READELF OBJDUMP NM FILE QEMU ARCH ABI SYSROOT QEMU_LD_PREFIX QEMU_OPTS
