# Use the default kernel version if the Makefile doesn't override it

LINUX_RELEASE?=1

LINUX_VERSION-3.14 =
#LINUX_VERSION-3.18 = .20
LINUX_VERSION-3.18 = .0
LINUX_VERSION-3.19 = .3

LINUX_KERNEL_MD5SUM-3.14 = 2fd2ce6b655d60c428a5d3c53d77a183
#LINUX_KERNEL_MD5SUM-3.18.20 = 952c9159acdf4efbc96e08a27109d994
LINUX_KERNEL_MD5SUM-3.18.0 = 5aeb8d416a211a63e88866e6a18bfc57
LINUX_KERNEL_MD5SUM-3.19.3 = 1d5665814e60c98b65329fa70e440498

ifdef KERNEL_PATCHVER
  LINUX_VERSION:=$(KERNEL_PATCHVER)$(strip $(LINUX_VERSION-$(KERNEL_PATCHVER)))
endif

split_version=$(subst ., ,$(1))
merge_version=$(subst $(space),.,$(1))
KERNEL_BASE=$(firstword $(subst -, ,$(LINUX_VERSION)))
KERNEL=$(call merge_version,$(wordlist 1,2,$(call split_version,$(KERNEL_BASE))))
KERNEL_PATCHVER ?= $(KERNEL)

# disable the md5sum check for unknown kernel versions
LINUX_KERNEL_MD5SUM:=$(LINUX_KERNEL_MD5SUM-$(strip $(LINUX_VERSION)))
LINUX_KERNEL_MD5SUM?=x
