#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=ls1012a
BOARDNAME:=LS1012A
FEATURES:=fpu ramdisk
CFLAGS:=-Os -pipe -fno-caller-saves
SUBTARGETS=hgw

#KERNEL_PATCHVER:=3.18
KERNEL_PATCHVER:=3.19

DEVICE_TYPE:=developerboard

include $(INCLUDE_DIR)/target.mk

LINUX_PROFILE_CONFIG:=$(CURDIR)/$(SUBTARGET)/configs/$(PROFILE)

define Target/Description
	Build firmeare images for Freescale Layerscape SoC
endef
ifeq ($(CONFIG_DEV_KERNEL),y)
ifeq ($(CONFIG_DEV_KERNEL_GITBRANCH), "")
define Kernel/Prepare
	mkdir -p $(KERNEL_BUILD_DIR)
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_KERNEL_MODULENAME) linux-$(LINUX_VERSION) && \
	popd
endef
else
define Kernel/Prepare
	mkdir -p $(KERNEL_BUILD_DIR)
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_KERNEL_MODULENAME) linux-$(LINUX_VERSION) &&  \
	pushd "linux-$(LINUX_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_KERNEL_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_KERNEL_GITBRANCH) $(CONFIG_DEV_KERNEL_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_KERNEL_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_KERNEL_GITBRANCH) origin/$(CONFIG_DEV_KERNEL_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_KERNEL_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd; \
	popd
endef
endif
endif

#KERNELNAME:=Image uImage dtbs
KERNELNAME:=Image dtbs

$(eval $(call BuildTarget))
