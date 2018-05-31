PLATFORM?=C2000

ifeq ($(PLATFORM),C2000)
CROSS_COMPILE?=
KERNELDIR?=
ARCH=arm
else
ARCH=x86
KERNELDIR=/lib/modules/`uname -r`/build
endif
all: modules

modules clean:
	make CROSS_COMPILE=$(CROSS_COMPILE) V=1 ARCH=$(ARCH) -C $(KERNELDIR) M=`pwd` $@

EXTRA_CFLAGS += -DENDIAN_LITTLE -DGCC_TOOLCHAIN -DCOMCERTO_2000 -DCOMCERTO_2000_CONTROL

obj-m += msp_coredump.o
msp_coredump-y += comcerto_coredump.o

